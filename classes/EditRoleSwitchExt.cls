public with sharing class EditRoleSwitchExt
{
    public string RoleId{get;set;}
    public EditRoleSwitchExt(ApexPages.StandardController controller) 
    {
        RoleId= controller.getRecord().id;
    }

}