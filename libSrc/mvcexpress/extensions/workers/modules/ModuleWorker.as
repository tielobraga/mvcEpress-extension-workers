package mvcexpress.extensions.workers.modules {
import flash.utils.ByteArray;

import mvcexpress.MvcExpress;
import mvcexpress.core.ExtensionManager;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.extensions.workers.core.WorkerManager;
import mvcexpress.extensions.workers.core.traceObjects.moduleBase.TraceModuleBase_sendWorkerMessage;
import mvcexpress.modules.ModuleCore;

public class ModuleWorker extends ModuleCore {

	// worker support
	private static var needWorkerSupportCheck:Boolean = true;

	// true if workers are supported.
	private static var _isWorkersSupported:Boolean;// = false;

	// TEMP... for Debug only..
	/**debug:worker**/public var debug_objectID:int = Math.random() * 100000000;

	/**
	 * CONSTRUCTOR. ModuleName must be provided.
	 * @inheritDoc
	 */
	public function ModuleWorker(moduleName:String, mediatorMapClass:Class = null, proxyMapClass:Class = null, commandMapClass:Class = null, messengerClass:Class = null) {

		/**debug:worker**/trace("     [" + moduleName + "]" + "ModuleWorker: try to create module."
		/**debug:worker**/ + "[" + WorkerManager.debug_coreId + "]" + "<" + debug_objectID + "> ");

		use namespace pureLegsCore;

		CONFIG::debug {
			enableExtension(EXTENSION_WORKER_ID);
		}

		if (needWorkerSupportCheck) {
			needWorkerSupportCheck = false;
			_isWorkersSupported = WorkerManager.checkWorkerSupport();
		}

		// stores if this module will be created. (then same swf file is used to create other modules - main module will not be created.)
		var canCreateModule:Boolean = true;

		if (_isWorkersSupported) {
			canCreateModule = WorkerManager.initWorker(moduleName
					/**debug:worker**/, debug_objectID
			);
		} else {
			trace("TODO - implement scenario then workers are not supported.");
			//if (ModuleScopedWorker.canInitChildModule) {
			//
			//	// todo : get this name better.
			//	var workerModuleName:String = WorkerIds.MAIN_WORKER;
			//
			//	ScopeManager.registerScope(debug_moduleName, workerModuleName, true, true, false);
			//	ScopeManager.registerScope(debug_moduleName, debug_moduleName, true, true, false);
			//	ScopeManager.registerScope(workerModuleName, workerModuleName, true, true, false);
			//}
		}

		if (canCreateModule) {
			/**debug:worker**/trace("     [" + moduleName + "]" + "ModuleWorker: Create module!"
			/**debug:worker**/ + "[" + WorkerManager.debug_coreId + "]" + "<" + debug_objectID + "> ");
			super(moduleName, mediatorMapClass, proxyMapClass, commandMapClass, messengerClass);
		}

	}

	/**
	 * Starts background worker.
	 *        If workerSwfBytes property is not provided - rootSwfBytes will be used.
	 * @param workerModuleClass
	 * @param workerModuleName
	 * @param workerSwfBytes    bytes of loaded swf file.
	 */
	public function startWorker(workerModuleClass:Class, workerModuleName:String, workerSwfBytes:ByteArray = null):void {

		// todo : implement optional module parameters for extendability.
		use namespace pureLegsCore;

		WorkerManager.startWorker(moduleName, workerModuleClass, workerModuleName, workerSwfBytes
				/**debug:worker**/, debug_objectID
		);
	}

	/**
	 * terminates background worker and dispose worker module.
	 * @param workerModuleName
	 */
	public function terminateWorker(workerModuleName:String):void {
		use namespace pureLegsCore;

		WorkerManager.terminateWorker(workerModuleName
				/**debug:worker**/, moduleName, debug_objectID
		);
	}


	//----------------------------------
	//   Worker MESSAGING
	//----------------------------------

	/**
	 * Sends message for other framework actors to react to.
	 * @param    type    type of the message. (Commands and handle functions must be mapped to type to be triggered.)
	 * @param    params    Object that will be send to Command execute() or to handle function as parameter.
	 */
	public function sendWorkerMessage(remoteWorkerModuleName:String, type:String, params:Object = null):void {
		use namespace pureLegsCore;

		// log the action
		CONFIG::debug {
			MvcExpress.debug(new TraceModuleBase_sendWorkerMessage(moduleName, this, type, params, true));
		}
		//
		WorkerManager.sendWorkerMessage(moduleName, remoteWorkerModuleName, type, params);
		//
		// clean up logging
		CONFIG::debug {
			MvcExpress.debug(new TraceModuleBase_sendWorkerMessage(moduleName, this, type, params, false));
		}
	}

	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	/** @private */
	CONFIG::debug
	static pureLegsCore const EXTENSION_WORKER_ID:int = ExtensionManager.getExtensionIdByName(pureLegsCore::EXTENSION_WORKER_NAME);

	/** @private */
	CONFIG::debug
	static pureLegsCore const EXTENSION_WORKER_NAME:String = "workers";

}
}