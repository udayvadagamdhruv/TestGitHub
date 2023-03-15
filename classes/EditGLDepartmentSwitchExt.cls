public with sharing class EditGLDepartmentSwitchExt
{
    public string GLDepId{get;set;}
    public EditGLDepartmentSwitchExt(ApexPages.StandardController controller) 
    {
        GLDepId= controller.getRecord().id;
    }

}