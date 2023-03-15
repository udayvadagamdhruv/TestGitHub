public with sharing class EditScheduleTemplateSwitchExt
{
    public string SchedId{get;set;}
    public EditScheduleTemplateSwitchExt(ApexPages.StandardController controller) 
    {
        SchedId= controller.getRecord().id;
    }

}