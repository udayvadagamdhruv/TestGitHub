global with sharing class ScheduleforRefreshAccessToken implements Schedulable {

    global void execute(SchedulableContext sc){

       BatchClassforRefreshAccessToken DB=new BatchClassforRefreshAccessToken();
       Database.executeBatch(DB,200);
  
    }
}