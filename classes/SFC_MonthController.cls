public with sharing class SFC_MonthController{
   public list<list<integer>> days {get;set;}
    public integer month {get;set;}
    public integer year {get;set;}
    public string monthname {get;set;}
    public string holidays {get;set;}

    //All initial logic goes here
    public void getPrintCalendar(){
        days = new list<list<integer>>();
        days.add(new list<integer>{0,0,0,0,0,0,0});
        days.add(new list<integer>{0,0,0,0,0,0,0});
        days.add(new list<integer>{0,0,0,0,0,0,0});
        days.add(new list<integer>{0,0,0,0,0,0,0});
        days.add(new list<integer>{0,0,0,0,0,0,0});
        days.add(new list<integer>{0,0,0,0,0,0,0});
        days.add(new list<integer>{0,0,0,0,0,0,0});
        Date theDate = Date.newInstance(year, month, 01);
        DateTime dtime = DateTime.newInstance(year, month, 01, 0, 0, 0);
        monthname = dtime.format('MMMM');
        Date weekStart = theDate.toStartofWeek();
        Integer dayOfWeek = weekStart.daysBetween(theDate);
        integer row = 0;
        
        if(dayOfWeek == 0){
            dayOfWeek = 6;
        }else{
            dayOfWeek--;
        }
        set<integer> hds = new set<integer>();
        if(holidays != null){
            for(string s: holidays.split(',')){
                hds.add(integer.valueOf(s));
            }
        }
        integer dayOfMonth = 1;
        
        //filling dates
        for(integer i=1;i<=Date.daysInMonth(year,month);i++){
            system.debug('row ' + row + ' - col - ' + dayOfWeek);
            if(days[row][dayOfWeek] < 0)
                days[row][dayOfWeek] = -1 * i;
            else
                days[row][dayOfWeek] = i;
            dayOfWeek++;
            if(dayOfWeek > 6){
                row++;
                dayOfWeek = 0;
            }
            
        }
        
        //setting up holidays
        for(integer r=0;r<7;r++){
            for(integer c=0;c<7;c++){
                if(hds.size() > 0 && hds.contains(days[r][c]) && days[r][c] > 0){
                    days[r][c] = -1 * days[r][c];
                }
            }
        }
    }   
}