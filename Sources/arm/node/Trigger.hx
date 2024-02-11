package arm.node;

@:access(armory.logicnode.LogicNode)@:keep class Trigger extends armory.logicnode.LogicTree {

	var functionNodes:Map<String, armory.logicnode.FunctionNode>;

	var functionOutputNodes:Map<String, armory.logicnode.FunctionOutputNode>;

	public function new() {
		super();
		this.functionNodes = new Map();
		this.functionOutputNodes = new Map();
		notifyOnAdd(add);
	}

	override public function add() {
		var _Print = new armory.logicnode.PrintNode(this);
		_Print.preallocInputs(2);
		_Print.preallocOutputs(1);
		var _IsTrue = new armory.logicnode.IsTrueNode(this);
		_IsTrue.preallocInputs(2);
		_IsTrue.preallocOutputs(1);
		var _OnUpdate = new armory.logicnode.OnUpdateNode(this);
		_OnUpdate.property0 = "Update";
		_OnUpdate.preallocInputs(0);
		_OnUpdate.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(_OnUpdate, _IsTrue, 0, 0);
		var _VolumeTrigger = new armory.logicnode.VolumeTriggerNode(this);
		_VolumeTrigger.property0 = "end";
		_VolumeTrigger.preallocInputs(2);
		_VolumeTrigger.preallocOutputs(1);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, "triggerFrenteEnemigo.001"), _VolumeTrigger, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.ObjectNode(this, "Cube.002"), _VolumeTrigger, 0, 1);
		armory.logicnode.LogicNode.addLink(_VolumeTrigger, _IsTrue, 0, 1);
		armory.logicnode.LogicNode.addLink(_IsTrue, _Print, 0, 0);
		armory.logicnode.LogicNode.addLink(new armory.logicnode.StringNode(this, "TRIGGER ENGER"), _Print, 0, 1);
		armory.logicnode.LogicNode.addLink(_Print, new armory.logicnode.NullNode(this), 0, 0);
	}
}