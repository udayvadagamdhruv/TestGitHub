/**
    Author - Jitendra Zaa
    This controller class is used by the VF page "GanttChartData" to generate the JSON
*/
public with sharing class GanttChartData {

    public String jsonString {get;set;}
    
    //Constructor
    public GanttChartData()
    {
        jsonString = prepareData();

    }   
    //Temp Method to prepare the Data
    private String prepareData()
    {
        List<ReservationDetail> dtlObj = new List<ReservationDetail>();
        
        ReservationDetail obj1 = new ReservationDetail();
        ReservationDetail obj2 = new ReservationDetail();
        ReservationDetail obj3 = new ReservationDetail();
        
        obj1.setFromDate(String.valueOf(datetime.newInstance(2015,04, 17, 0, 0, 0).getTime())); 
        obj1.setToDate(String.valueOf(datetime.newInstance(2015,04, 17, 05, 30, 0).getTime()));
        obj1.desc_PH = 'Booked by : Jitendra <br /> for JQuery Demo';
        obj1.label = 'Jitendra';
        obj1.customClass = 'ganttRed';
        
        obj2.setFromDate(String.valueOf(datetime.newInstance(2012,04, 17, 20, 30, 0).getTime()));
        obj2.setToDate(String.valueOf(datetime.newInstance(2012,04, 17, 23, 30, 2).getTime()));
        obj2.desc_PH = 'Booked by : Tuiya <br /> for Wireless Lecture';
        obj2.label = 'Tuiya';
        obj2.customClass = 'ganttOrange';
        
        
        obj3.setFromDate(String.valueOf(datetime.newInstance(2012,04, 19, 09, 30, 0).getTime()));
        obj3.setToDate(String.valueOf(datetime.newInstance(2012,04, 19, 16, 30, 2).getTime()));
        obj3.desc_PH = 'Booked by : Santosh <br /> for SAP Basis';
        obj3.label = 'Santosh';
        obj3.customClass = 'ganttGreen';
        
        dtlObj.add(obj1);
        dtlObj.add(obj2);
        dtlObj.add(obj3);
        
        Room r = new Room();
        r.name = 'Training Room';
        r.desc_PH = 'This is Training Room';
        r.values = dtlObj;
        
        Room r2 = new Room();
        r2.name = 'Training Room2';
        r2.desc_PH = 'This is Training Room2';
        r2.values = dtlObj;
        
        List<Room> r1 = new List<Room>();
        r1.add(r);
        r1.add(r2);
        
            
        return JSON.serialize(r1).replaceAll('frm_PH','from').replaceAll('desc_PH','desc');
    }
    public class RoomList
    {
        public List<Room> rooms;
    }
    public class Room
    {
        public String name{get;set;}
        //Below var name - desc
        public String desc_PH{get;set;}
        public List<ReservationDetail> values{get;set;}
    } 
    
    public class ReservationDetail
    {
        //actual variable name needed was "from", but it is keyword so we cant use that
        public String frm_PH{get;set;}
        public String to{get;set;}
        
        public String desc_PH{get;set;}
        public String label{get;set;}
        
        /*
            Custom class Can be anything from below:
            ganttRed
            ganttGreen
            ganttOrange
            
        */
        public String customClass{get;set;}
        
        public void setToDate(String val)
        {
            to = setDate(val);
        }
        public void setFromDate(String val)
        {
            frm_PH = setDate(val);
        }
        //Date should be in special format as it is used in regular expression
        private String setDate(String val)
        {
            return '/Date('+val+')/';
        }
    }
}