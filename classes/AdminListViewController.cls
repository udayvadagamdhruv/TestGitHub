// This controller is used to handle navigation between second level tabs under Admin Tab
public with sharing class AdminListViewController
{
    // Global Variables
   /* public String tabInFocus{get;set;}
    String intTabFocus;
    // End of Global variables 
    
    // Start Constructor 
    public AdminListViewController() 
    {
        intTabFocus = System.currentPageReference().GetParameters().get('intFocus');
        
       //   Apexpages.addMessage(New Apexpages.Message(Apexpages.severity.info,''+intTabFocus));
        
        if(intTabFocus=='1')
        {
            tabInFocus = 'GL Codes';
        }
        if(intTabFocus=='2')
        {
            tabInFocus = 'Schedule Templates';
        }
        if(intTabFocus=='3')
        {
            tabInFocus = 'Specification Templates';
        }
        if(intTabFocus=='4')
        {
            tabInFocus = 'Holidays';
        }
         if(intTabFocus=='5')
        {
            tabInFocus = 'Staff';
        }
         if(intTabFocus=='6')
        {
            tabInFocus = 'Roles';
        }
     /*   if(intTabFocus=='7')
        {
            tabInFocus = 'Campaign';
        } 
        if(intTabFocus=='8')
        {
            tabInFocus = 'Media Type';
        }
         if(intTabFocus=='9')
        {
            tabInFocus = 'GL Department';
        }
        if(intTabFocus=='10')
        {
            tabInFocus = 'Production Spec Templates';
        }
        //added by yogini on 29-Apr-13
        if(intTabFocus=='11')
        {
            tabInFocus = 'Tag Template';
        }
        
        if(intTabFocus=='12')
        {
            tabInFocus = 'Invoice Allocation Templates';
        }
        
         if(intTabFocus=='13')
        {
            tabInFocus = 'Production Estimate Templates';
        }
        
        if(intTabFocus=='14')
        {
            tabInFocus = 'Estimate Templates';
        }
        
        if(intTabFocus=='15')
        {
            tabInFocus = 'Campaign Templates';
        }
        
        
        //End
        
        
    }
    // End of Contstructor 
    
      /*  // Start Test Coverage
        static testMethod void Test_AdminListViewController()
        {
             ApexPages.currentPage().getParameters().put('intFocus', '1');
             AdminListViewController ext1=new AdminListViewController();
             
             System.assertEquals('GL Codes',ext1.tabInFocus);
             
             ApexPages.currentPage().getParameters().put('intFocus', '2');
             AdminListViewController ext2=new AdminListViewController();
 
             ApexPages.currentPage().getParameters().put('intFocus', '3');
             AdminListViewController ext3=new AdminListViewController();
             
             ApexPages.currentPage().getParameters().put('intFocus','4');
             AdminListViewController ext4=new AdminListViewController();
             
             ApexPages.currentPage().getParameters().put('intFocus', '5');
             AdminListViewController ext5=new AdminListViewController();
 
             ApexPages.currentPage().getParameters().put('intFocus', '6');
             AdminListViewController ext6=new AdminListViewController();
             
           //  ApexPages.currentPage().getParameters().put('intFocus','7');
            // AdminListViewController ext7=new AdminListViewController(); 
             
             ApexPages.currentPage().getParameters().put('intFocus','8');
             AdminListViewController ext8=new AdminListViewController();
             
             ApexPages.currentPage().getParameters().put('intFocus','9');
             AdminListViewController ext9=new AdminListViewController();
             
             ApexPages.currentPage().getParameters().put('intFocus','10');
             AdminListViewController ext10=new AdminListViewController();
        }
        
        */
        
        
        // End Test Coverage
        
        
}
// End of class AdminListViewController