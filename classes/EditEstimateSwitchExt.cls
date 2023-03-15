public with sharing class EditEstimateSwitchExt {

    public string EstId{get;set;}
    
    public EditEstimateSwitchExt(ApexPages.StandardController controller) 
    {
        EstId = controller.getRecord().id;
    }

}