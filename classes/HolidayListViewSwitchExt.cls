public with sharing class HolidayListViewSwitchExt {
 
 public boolean isLtng {set;get{
 
          return (UserInfo.getUITheme()=='Theme4d')?true:false;
 }}

   public string hldayprefix;
    public HolidayListViewSwitchExt(ApexPages.StandardController controller) {
    hldayprefix=Holiday__c.SobjectType.getDescribe().getKeyPrefix();
    }

  public pageReference hollistview()
  
  {
    pageReference p;
    if(isLtng)
    {
      p=new pageReference ('/'+hldayprefix+'/o');
    }
   else
   {
     p =  new Pagereference('/apex/AdminListView?intFocus=4');
   }
    p.setredirect(true);
    return p;
  
  }


}