({
    doInit : function(component, event, helper) {
        console.log(component.get('v.recordId'));
        helper.getStatusWithAction1Map(component,event);
    },
    onChangeValueOfStatus : function(component, event, helper) {
        
        helper.onChangeValueOfStatusHelper(component,event);
    },
    onChangeValueOfAction1 : function(component, event, helper) {
        
       helper.onChangeValueOfAction1Helper(component,event);

    },

    saveHandleClick: function(component,event,helper){
        helper.saveDispositionValues(component,event);
    }
    
    
})
