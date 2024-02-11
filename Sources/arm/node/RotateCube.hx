package arm.node;

@:access(armory.logicnode.LogicNode)@:keep class RotateCube extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _RotateObject = new armory.logicnode.RotateObjectNode(this);
		_RotateObject.property0 = "Local";
		_RotateObject.preallocInputs(3);
		_RotateObject.preallocOutputs(1);
		var _OnUpdate = new armory.logicnode.OnUpdateNode(this);
		_OnUpdate.property0 = "Update";
		_OnUpdate.preallocInputs(0);
		_OnUpdate.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(_OnUpdate, _RotateObject, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, ""), _RotateObject, 0, 1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.RotationNode(this, 0.0,0.0,0.04991671070456505,0.9987502694129944), _RotateObject, 0, 2);
		armory.logicnode.LogicNode.addLink(_RotateObject, new armory.logicnode.NullNode(this), 0, 0);
	}
}