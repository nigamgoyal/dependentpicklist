public with sharing class DependentPicklist {
    public DependentPicklist() {

    }

    @AuraEnabled
    public  static Map<String,List<String>> getDependentOptions(String ObjName,
                             String controllingFieldName, String dependentFieldName){

        Map<String,List<String>> objResults = new Map<String,List<String>>();
        
        Map<String, Schema.SObjectField> objFieldMap = 
                                            Schema.getGlobalDescribe().get(ObjName)
                                            .getDescribe().fields.getMap();
        
          
        List<Schema.PicklistEntry> controllingPicklist = objFieldMap.get(controllingFieldName)
                                                            .getDescribe().getPicklistValues();
    
        List<Schema.PicklistEntry> dependentPicklist = objFieldMap.get(dependentFieldName)
                                                            .getDescribe().getPicklistValues();

        
        PickListUtils.Bitset objBitSet = new PickListUtils.Bitset();
        Integer controllingPicklistSize = controllingPicklist.size();
        //set up the results
        for(Integer controllingIndex=0; controllingIndex < controllingPicklistSize; controllingIndex++){            
            //get the pointer to the entry
            Schema.PicklistEntry controllingPickListEntry = controllingPicklist[controllingIndex];
            //get the label
            String controllingPickListEntryLabel = controllingPickListEntry.getLabel();
            //create the entry with the label
            objResults.put(controllingPickListEntryLabel,new List<String>());
        }
        Integer dependentPicklistSize = dependentPicklist.size(); 
        //check the dependent values
        for(Integer dependentIndex=0; dependentIndex < dependentPicklistSize; dependentIndex++){            
            //get the pointer to the dependent index
            Schema.PicklistEntry dependentPicklistEntry = dependentPicklist[dependentIndex];
            //get the valid for
            String entryStructure = JSON.serialize(dependentPicklistEntry);                
            PickListUtils.PicklistDetails objDependentPicklistDetails = (PickListUtils.PicklistDetails)JSON.deserialize(entryStructure, PickListUtils.PicklistDetails.class);
            //iterate through the controlling values
            for(Integer controllingIndex=0; controllingIndex < controllingPicklistSize; controllingIndex++){    
                if (objBitSet.fitBit(objDependentPicklistDetails.validFor,controllingIndex)){                    
                    //get the label
                    String controllingLabel = controllingPicklist[controllingIndex].getLabel();
                    objResults.get(controllingLabel).add(objDependentPicklistDetails.label);
                }
            }
        } 
        return objResults;
    }

    public static void getPickListValues(){
        //URL.getSalesforceBaseUrl().toExternalForm()
        String apiUrl = 'https://data-nosoftware-7180-dev-ed.cs58.my.salesforce.com/services/data/v43.0/ui-api/object-info/Lead/picklist-values/012000000000000AAA';
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(apiUrl);
        req.setMethod('GET');
        HttpResponse res = http.send(req);
        System.debug(res.getBody());
    }
}




