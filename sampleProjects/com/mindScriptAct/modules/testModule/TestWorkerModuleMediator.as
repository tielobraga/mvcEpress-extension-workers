package com.mindScriptAct.modules.testModule {
import com.mindScriptAct.modules.testModule.data.TestDataNestVO;
import com.mindScriptAct.modules.testModule.data.TestDataSwapVO;
import com.mindScriptAct.modules.testModule.data.TestDataVO;
import com.mindScriptAct.workerTest.WorkerIds;
import com.mindScriptAct.workerTest.data.MainDataNestVO;
import com.mindScriptAct.workerTest.data.MainDataSwapTestVO;
import com.mindScriptAct.workerTest.data.MainDataVO;
import com.mindScriptAct.workerTest.messages.Messages;

import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import mvcexpress.extensions.scoped.mvc.MediatorScoped;

import org.mvcexpress.extensions.workers.modules.ModuleWorkerBase;

/**
 * TODO:CLASS COMMENT
 * @author Deril
 */
public class TestWorkerModuleMediator extends MediatorScoped {

	[Inject]
	public var view:TestWorkerModule;

	private var to1:int;
	private var to2:int;
	private var to3:int;
	private var to4:int;

	override protected function onRegister():void {

		addScopeHandler(WorkerIds.TEST2_WORKER_MODULE, Messages.MAIN_TEST2, handleWorkerString);
		addScopeHandler(WorkerIds.TEST2_WORKER_MODULE, Messages.MAIN_TEST2_OBJECT, handleWorkerObject);
		addScopeHandler(WorkerIds.TEST2_WORKER_MODULE, Messages.MAIN_TEST2_OBJECT_SWAP, handleWorkerObjectSwap);
		addScopeHandler(WorkerIds.TEST2_WORKER_MODULE, Messages.MAIN_TEST2_OBJECT_NEST, handleWorkerObjectNest);
//
		to1 = setTimeout(sendString, 1000 + 8000);
		to2 = setTimeout(sendObject, 3000 + 8000);
		if (ModuleWorkerBase.isWorkersSupported) {
			to3 = setTimeout(sendObjectSwap, 5000 + 8000);
		}
		to4 = setTimeout(sendObjectNest, 7000 + 8000);

//		sendString();
//		sendObject();
//		sendObjectNest();


//		setTimeout(sendObjectNest, 2000);

		addScopeHandler(WorkerIds.TEST2_WORKER_MODULE, Messages.MAIN_TEST2_CALC, handleMainCalc);
	}

	private function handleMainCalc(testNumber:int):void {
		sendScopeMessage(WorkerIds.MAIN_WORKER_TEST_MODULE, Messages.TEST2_MAIN_CALC, "Test2 mult2... " + (testNumber * 2));
	}

	////////////////////////////////

	private function sendString():void {
		trace("	[" + view.moduleName + "]" + ">>TestWorkerModule:sendString();", "Debug module name: " + view.debug_getModuleName()
				+ "	[" + ModuleWorkerBase.debug_coreId + "]" + "<" + view.debug_objectID + "> ");
		//MonsterDebugger.log("[" + ModuleWorkerBase.coreId + "]" + "<" + objectID + "> " + "[" + moduleName + "]" + "TestWorkerModule:traceModule();");

		sendScopeMessage(WorkerIds.MAIN_WORKER_TEST_MODULE, Messages.TEST2_MAIN, "TEST2 > MAIN");
		to1 = setTimeout(sendString, 16000);
	}

	//*

	private function sendObject():void {
		trace("	[" + view.moduleName + "]" + ">>TestWorkerModule:sendObject();", "Debug module name: " + view.debug_getModuleName()
				+ "	[" + ModuleWorkerBase.debug_coreId + "]" + "<" + view.debug_objectID + "> ");
		//MonsterDebugger.log("[" + ModuleWorkerBase.coreId + "]" + "<" + objectID + "> " + "[" + moduleName + "]" + "TestWorkerModule:traceModule();");

		sendScopeMessage(WorkerIds.MAIN_WORKER_TEST_MODULE, Messages.TEST2_MAIN_OBJECT, new TestDataVO("TEST2 >> MAIN"));
		to2 = setTimeout(sendObject, 16000);
	}

	private function sendObjectSwap():void {
		trace("	[" + view.moduleName + "]" + ">>TestWorkerModule:sendObjectSwap();", "Debug module name: " + view.debug_getModuleName()
				+ "	[" + ModuleWorkerBase.debug_coreId + "]" + "<" + view.debug_objectID + "> ");
		//MonsterDebugger.log("[" + ModuleWorkerBase.coreId + "]" + "<" + objectID + "> " + "[" + moduleName + "]" + "TestWorkerModule:traceModule();");

		sendScopeMessage(WorkerIds.MAIN_WORKER_TEST_MODULE, Messages.TEST2_MAIN_OBJECT_SWAP, new TestDataSwapVO("TEST2 >>> MAIN"));
		to3 = setTimeout(sendObjectSwap, 16000);
	}


	private function sendObjectNest():void {
		trace("	[" + view.moduleName + "]" + ">>TestWorkerModule:sendObjectNest();", "Debug module name: " + view.debug_getModuleName()
				+ "	[" + ModuleWorkerBase.debug_coreId + "]" + "<" + view.debug_objectID + "> ");
		//MonsterDebugger.log("[" + ModuleWorkerBase.coreId + "]" + "<" + objectID + "> " + "[" + moduleName + "]" + "TestWorkerModule:traceModule();");

		sendScopeMessage(WorkerIds.MAIN_WORKER_TEST_MODULE, Messages.TEST2_MAIN_OBJECT_NEST, new TestDataNestVO("TEST2 >>>> MAIN"));
		to4 = setTimeout(sendObjectNest, 16000);
	}

	// */

	////////////////////////////////

	//*
	private function handleWorkerString(params:Object):void {
		//		trace("[" + ModuleWorkerBase.debug_coreId + "]" + "<" + view.debug_objectID + "> " + "[" + view.moduleName + "]", "!!!!!!!!!!!!!!!! TestWorkerModuleMediator received message:", params);
		trace("9: " + params, "!!!!!!!!!!!!!!!! TestWorkerModuleMediator received string:", "[" + ModuleWorkerBase.debug_coreId + "]" + "<" + view.debug_objectID + "> " + "[" + view.moduleName + "]");
	}

	private function handleWorkerObject(params:MainDataVO):void {
		//		trace("[" + ModuleWorkerBase.debug_coreId + "]" + "<" + view.debug_objectID + "> " + "[" + view.moduleName + "]", "!!!!!!!!!!!!!!!! TestWorkerModuleMediator received message:", params);
		trace("11: " + params, "!!!!!!!!!!!!!!!! TestWorkerModuleMediator received object:", "[" + ModuleWorkerBase.debug_coreId + "]" + "<" + view.debug_objectID + "> " + "[" + view.moduleName + "]");
	}

	private function handleWorkerObjectSwap(params:MainDataSwapTestVO):void {
		//		trace("[" + ModuleWorkerBase.debug_coreId + "]" + "<" + view.debug_objectID + "> " + "[" + view.moduleName + "]", "!!!!!!!!!!!!!!!! TestWorkerModuleMediator received message:", params);
		trace("13: " + params, "!!!!!!!!!!!!!!!! TestWorkerModuleMediator received swapped object:", "[" + ModuleWorkerBase.debug_coreId + "]" + "<" + view.debug_objectID + "> " + "[" + view.moduleName + "]");
	}

	private function handleWorkerObjectNest(params:MainDataNestVO):void {
		//		trace("[" + ModuleWorkerBase.debug_coreId + "]" + "<" + view.debug_objectID + "> " + "[" + view.moduleName + "]", "!!!!!!!!!!!!!!!! TestWorkerModuleMediator received message:", params);
		trace("15: " + params, "!!!!!!!!!!!!!!!! TestWorkerModuleMediator received nested object:", "[" + ModuleWorkerBase.debug_coreId + "]" + "<" + view.debug_objectID + "> " + "[" + view.moduleName + "]");
	}

	override protected function onRemove():void {
//		trace("TODO - implement TestWorkerModuleMediator function: onRemove().");

		clearTimeout(to1);
		clearTimeout(to2);
		clearTimeout(to3);
		clearTimeout(to4);


	}

	//*/

}
}