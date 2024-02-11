package arm.node;

@:access(armory.logicnode.LogicNode)@:keep class Spawner_enemigos extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _SpawnScene = new armory.logicnode.SpawnSceneNode(this);
		_SpawnScene.preallocInputs(3);
		_SpawnScene.preallocOutputs(2);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.NullNode(this), _SpawnScene, 0, 0);
		var _Scene = new armory.logicnode.SceneNode(this);
		_Scene.property0 = "EnemigoPrincipal";
		_Scene.preallocInputs(0);
		_Scene.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(_Scene, _SpawnScene, 0, 1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.NullNode(this), _SpawnScene, 0, 2);
		armory.logicnode.LogicNode.addLink(_SpawnScene, new armory.logicnode.NullNode(this), 0, 0);
		armory.logicnode.LogicNode.addLink(_SpawnScene, new armory.logicnode.ObjectNode(this, ""), 1, 0);
		var _SpawnObject = new armory.logicnode.SpawnObjectNode(this);
		_SpawnObject.preallocInputs(4);
		_SpawnObject.preallocOutputs(2);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.NullNode(this), _SpawnObject, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, ""), _SpawnObject, 0, 1);
		var _GetObjectTransform_001 = new armory.logicnode.GetTransformNode(this);
		_GetObjectTransform_001.preallocInputs(1);
		_GetObjectTransform_001.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, "SpannerEmpty"), _GetObjectTransform_001, 0, 0);
		armory.logicnode.LogicNode.addLink(_GetObjectTransform_001, _SpawnObject, 0, 2);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, true), _SpawnObject, 0, 3);
		armory.logicnode.LogicNode.addLink(_SpawnObject, new armory.logicnode.NullNode(this), 0, 0);
		armory.logicnode.LogicNode.addLink(_SpawnObject, new armory.logicnode.ObjectNode(this, ""), 1, 0);
		var _SpawnObject_001 = new armory.logicnode.SpawnObjectNode(this);
		_SpawnObject_001.preallocInputs(4);
		_SpawnObject_001.preallocOutputs(2);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.NullNode(this), _SpawnObject_001, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, "EnemigoPrincipal"), _SpawnObject_001, 0, 1);
		var _GetObjectTransform = new armory.logicnode.GetTransformNode(this);
		_GetObjectTransform.preallocInputs(1);
		_GetObjectTransform.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, "SpannerEmpty"), _GetObjectTransform, 0, 0);
		armory.logicnode.LogicNode.addLink(_GetObjectTransform, _SpawnObject_001, 0, 2);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, true), _SpawnObject_001, 0, 3);
		armory.logicnode.LogicNode.addLink(_SpawnObject_001, new armory.logicnode.NullNode(this), 0, 0);
		armory.logicnode.LogicNode.addLink(_SpawnObject_001, new armory.logicnode.ObjectNode(this, ""), 1, 0);
		var _SpawnScene_002 = new armory.logicnode.SpawnSceneNode(this);
		_SpawnScene_002.preallocInputs(3);
		_SpawnScene_002.preallocOutputs(2);
		var _OnTimer = new armory.logicnode.OnTimerNode(this);
		_OnTimer.preallocInputs(2);
		_OnTimer.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.FloatNode(this, 2.0), _OnTimer, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.BooleanNode(this, true), _OnTimer, 0, 1);
		armory.logicnode.LogicNode.addLink(_OnTimer, _SpawnScene_002, 0, 0);
		var _Scene_002 = new armory.logicnode.SceneNode(this);
		_Scene_002.property0 = "EnemigoPrincipal";
		_Scene_002.preallocInputs(0);
		_Scene_002.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(_Scene_002, _SpawnScene_002, 0, 1);
		var _GetObjectTransform_003 = new armory.logicnode.GetTransformNode(this);
		_GetObjectTransform_003.preallocInputs(1);
		_GetObjectTransform_003.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, "SpannerEmpty"), _GetObjectTransform_003, 0, 0);
		armory.logicnode.LogicNode.addLink(_GetObjectTransform_003, _SpawnScene_002, 0, 2);
		armory.logicnode.LogicNode.addLink(_SpawnScene_002, new armory.logicnode.NullNode(this), 0, 0);
		armory.logicnode.LogicNode.addLink(_SpawnScene_002, new armory.logicnode.ObjectNode(this, ""), 1, 0);
		var _SpawnScene_001 = new armory.logicnode.SpawnSceneNode(this);
		_SpawnScene_001.preallocInputs(3);
		_SpawnScene_001.preallocOutputs(2);
		var _OnInit = new armory.logicnode.OnInitNode(this);
		_OnInit.preallocInputs(0);
		_OnInit.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(_OnInit, _SpawnScene_001, 0, 0);
		var _Scene_001 = new armory.logicnode.SceneNode(this);
		_Scene_001.property0 = "EnemigoPrincipal";
		_Scene_001.preallocInputs(0);
		_Scene_001.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(_Scene_001, _SpawnScene_001, 0, 1);
		var _GetObjectTransform_002 = new armory.logicnode.GetTransformNode(this);
		_GetObjectTransform_002.preallocInputs(1);
		_GetObjectTransform_002.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, "SpannerEmpty"), _GetObjectTransform_002, 0, 0);
		armory.logicnode.LogicNode.addLink(_GetObjectTransform_002, _SpawnScene_001, 0, 2);
		armory.logicnode.LogicNode.addLink(_SpawnScene_001, new armory.logicnode.NullNode(this), 0, 0);
		armory.logicnode.LogicNode.addLink(_SpawnScene_001, new armory.logicnode.ObjectNode(this, ""), 1, 0);
	}
}