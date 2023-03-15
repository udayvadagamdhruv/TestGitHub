public with sharing class EditScheduleTaskSwitchExt
{
    public string SchTaskId{get;set;}
    public EditScheduleTaskSwitchExt(ApexPages.StandardController controller) 
    {
        SchTaskId = controller.getRecord().id;
    }

}