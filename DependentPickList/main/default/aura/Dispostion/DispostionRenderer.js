({

// Your renderer method overrides go here
rerender : function (component, helper) {
    this.superRerender();
    helper.onChangeValueOfStatusHelper(component);
    helper.onChangeValueOfAction1Helper(component);
	}
})
