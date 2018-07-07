({
    doInit : function(component, event, helper) {
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
                    console.log(statusOptions);
                    component.set('v.statusOptions',statusOptions);
                        
                    component.set('v.statusWithAction1Map',result);
                    console.log(component.get('v.statusWithAction1Map'));
                    var actionForSecondField = component.get('c.getDependentOptions');
                        actionForSecondField.setParams({ObjName:'Lead',
                        controllingFieldName:'Action_1__c',
                        dependentFieldName:'Action_2__c'});
                        actionForSecondField.setCallback(this,function(responseForSecondField){
                            if(state === 'SUCCESS'){
                                var resultForSecondField = responseForSecondField.getReturnValue();
                                //console.log(resultForSecondField);
                                component.set('v.action1WithAction2Map','');
                                component.set('v.action1WithAction2Map',resultForSecondField);
                                console.log(component.get('v.action1WithAction2Map'));
                            }else if(state ==='ERROR'){

                            }
                        });
                        $A.enqueueAction(actionForSecondField);
                }else if(state ==='ERROR'){

                }
            });

            $A.enqueueAction(action);
    },
    onChangeValueOfStatus : function(component, event, helper) {
        var selectedValueOfStatus = component.get('v.selectedValueOfStatus');
        console.log(selectedValueOfStatus);
        var statusWithAction1Map = component.get('v.statusWithAction1Map');
        var action1Options = [];
        action1Options.push({value:'',label:'--None--'});
        
        if(selectedValueOfStatus != ''){
            var action1List = statusWithAction1Map[selectedValueOfStatus];
            var action1ListLen = action1List.length;
            
            for(var ii = 0; ii < action1ListLen; ii++){
                var action1Option = {
                    value:action1List[ii] ,
                    label:action1List[ii]
                }
                action1Options.push(action1Option);
            }
        }
        component.set('v.action1Options',action1Options);

        var action2Options = [];
        action2Options.push({value:'',label:'--None--'});
        component.set('v.action2Options',action2Options);

    },
    onChangeValueOfAction1 : function(component, event, helper) {
        console.log('im abcd');
        var selectedValueOfAction1 = component.get('v.selectedValueOfAction1');
        console.log(selectedValueOfAction1);
        var action1WithAction2Map = component.get('v.action1WithAction2Map');
        var action2Options = [];
        action2Options.push({value:'',label:'--None--'});
        
        if(selectedValueOfAction1 != ''){
            var action2List = action1WithAction2Map[selectedValueOfAction1];
            var action2ListLen = action2List.length;
            
            for(var ii = 0; ii < action2ListLen; ii++){
                var action2Option = {
                    value:action2List[ii] ,
                    label:action2List[ii]
                }
                action2Options.push(action2Option);
            }
        }
       component.set('v.action2Options',action2Options);

    }
    
})
