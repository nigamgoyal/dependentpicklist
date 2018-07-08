({
    getExistingDispositionVal : function(component,event) {
        var getExistingDispositionValAction = component.get('c.getExistingDispositionValApx');
            getExistingDispositionValAction.setParams({recordId:component.get('v.recordId')});
            getExistingDispositionValAction.setCallback(this,function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                if(result.Status__c != null);
                    component.set('v.selectedValueOfStatus',result.Status__c);
                if(result.Action_1__c != null);
                    component.set('v.selectedValueOfAction1',result.Action_1__c);
                if(result.Action_2__c != null)
                    component.set('v.selectedValueOfAction2',result.Action_2__c);
                }else if(state ==='ERROR'){
                    
                }
            });
            $A.enqueueAction(getExistingDispositionValAction);
    },
    getStatusWithAction1Map: function(component,event){
        var that = this;
        var action = component.get('c.getDependentOptions');
            action.setParams({ObjName:'Lead',
            controllingFieldName:'Status__c',
            dependentFieldName:'Action_1__c'});
            action.setCallback(this,function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var result = response.getReturnValue();
                    //console.log(result);
                    var statusOptions = [];
                    var resultLen = result.length;
                    statusOptions.push({value:'',label:'--None--'});
                    for(var key in result){
                        
                        var statusOption = {
                            value:key,
                            label:key
                        }
                        statusOptions.push(statusOption);
                    }
                    
                    component.set('v.statusOptions',statusOptions);
                        
                    component.set('v.statusWithAction1Map',result);
                    that.getAction1WithAction2Map(component,event);    
                    that.getExistingDispositionVal(component,event);
                }else if(state ==='ERROR'){

                }
            });

            $A.enqueueAction(action);
    },
    getAction1WithAction2Map: function(component,event){
        var actionForSecondField = component.get('c.getDependentOptions');
        actionForSecondField.setParams({ObjName:'Lead',
        controllingFieldName:'Action_1__c',
        dependentFieldName:'Action_2__c'});
        actionForSecondField.setCallback(this,function(responseForSecondField){
            var state = responseForSecondField.getState();
            if(state === 'SUCCESS'){
                var resultForSecondField = responseForSecondField.getReturnValue();
                //console.log(resultForSecondField);
                component.set('v.action1WithAction2Map','');
                component.set('v.action1WithAction2Map',resultForSecondField);
                //console.log(component.get('v.action1WithAction2Map'));
            }else if(state ==='ERROR'){

            }
        });
        $A.enqueueAction(actionForSecondField);
    },
    onChangeValueOfStatusHelper:function(component,event){
        //console.log('called');
        //console.log(component.get('v.selectedValueOfStatus'));
        var selectedValueOfStatus = component.get('v.selectedValueOfStatus');
        
        var statusWithAction1Map = component.get('v.statusWithAction1Map');
        var action1Options = [];
        action1Options.push({value:'',label:'--None--'});
       // console.log(selectedValueOfStatus.length);
        if(selectedValueOfStatus){
            var action1List = statusWithAction1Map[selectedValueOfStatus];
            if(action1List && action1List.length > 0){
                var action1ListLen = action1List.length;
                
                for(var ii = 0; ii < action1ListLen; ii++){
                    var action1Option = {
                        value:action1List[ii] ,
                        label:action1List[ii]
                    }
                    action1Options.push(action1Option);
                }
            }
        }else{
            console.log('im else');
            component.set('v.selectedValueOfAction1','');
            component.set('v.selectedValueOfAction2','');
            //this.onChangeValueOfAction1Helper(component,event);
        }
        component.set('v.action1Options',action1Options);

        var action2Options = [];
        action2Options.push({value:'',label:'--None--'});
        component.set('v.action2Options',action2Options);
    },
    onChangeValueOfAction1Helper:function(component,event){
        
        console.log('im inner');
        component.set('v.action2Options',[{value:'',label:'--None--'}]);

        var selectedValueOfAction1 = component.get('v.selectedValueOfAction1');
        
        var action1WithAction2Map = component.get('v.action1WithAction2Map');
        var action2Options = [];
        action2Options.push({value:'',label:'--None--'});
        
        if(selectedValueOfAction1 != ''){
            var action2List = action1WithAction2Map[selectedValueOfAction1];
            if(action2List && action2List.length > 0){
                var action2ListLen = action2List.length;
            
                for(var ii = 0; ii < action2ListLen; ii++){
                    var action2Option = {
                        value:action2List[ii] ,
                        label:action2List[ii]
                    }
                    action2Options.push(action2Option);
                }
            }
            
        }
       component.set('v.action2Options',action2Options);
    },

    saveDispositionValues:function(component, event, helper) {
        var that = this;
        var saveValAction = component.get('c.saveDispositionValuesApx');
            saveValAction.setParams({
                recordId:component.get('v.recordId'),
                selectedValueOfStatus : component.get('v.selectedValueOfStatus'),
                selectedValueOfAction1: component.get('v.selectedValueOfAction1'),
                selectedValueOfAction2: component.get('v.selectedValueOfAction2'),
            });
            saveValAction.setCallback(this,function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var result = response.getReturnValue();
                    that.showSuccessToast(component,event);
                }else if(state ==='ERROR'){
                    var message='';
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            message = errors[0].message;
                        }
                    } else {
                        message = "Unknown error";
                        
                        //console.log("Unknown error");
                    }
                    that.showErrorToast(component,event,message);
                }
            });
            $A.enqueueAction(saveValAction);
    },
    showSuccessToast : function(component, event) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success!',
                    message: 'Record succesfully updated',
                    
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
    },
    showErrorToast : function(component, event, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error!',
            message:message,
            
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    }
})
