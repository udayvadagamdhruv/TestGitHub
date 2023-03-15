@isTest
private class Test_SFC_MonthController {

   static testMethod void myUnitTest() 
    {
    
    SFC_MonthController cls = new SFC_MonthController();
    cls.holidays = '10,12,13';
    cls.month = (system.today()).month();
    cls.year = (system.today()).year();
    cls.getPrintCalendar();
    
    }
       
}