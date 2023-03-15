({
	/* nextCall : function(component, event, helper, result){
        
        var dataLoop=[];   
        for(var i=0;i<result.length;i++){
            var r = result[i];                       
            dataLoop.push({"id":r.id, "text":r.Name, "start_date":new Date(2020,12, 01), "end_date":new Date(2020,12, 02), "progress":0, "open": true});
        }
        
        var demo_tasks1 = {
            "data":dataLoop
        };	
        
        
        var zoomConfig = {
            levels: [
                {
                    name:"day",
                    scale_height: 27,
                    min_column_width:80,
                    scales:[
                        {unit: "day", step: 1, format: "%d %M"}
                    ]
                },
                {
                    name:"week",
                    scale_height: 50,
                    min_column_width:50,
                    scales:[
                        {unit: "week", step: 1, format: function (date) {
                            var dateToStr = gantt.date.date_to_str("%d %M");
                            var endDate = gantt.date.add(date, -6, "day");
                            var weekNum = gantt.date.date_to_str("%W")(date);
                            return "#" + weekNum + ", " + dateToStr(date) + " - " + dateToStr(endDate);
                        }},
                        {unit: "day", step: 1, format: "%j %D"}
                    ]
                },
                {
                    name:"month",
                    scale_height: 50,
                    min_column_width:120,
                    scales:[
                        {unit: "month", format: "%F, %Y"},
                        {unit: "week", format: "Week #%W"}
                    ]
                },
                {
                    name:"quarter",
                    height: 50,
                    min_column_width:90,
                    scales:[
                        {unit: "month", step: 1, format: "%M"},
                        {
                            unit: "quarter", step: 1, format: function (date) {
                                var dateToStr = gantt.date.date_to_str("%M");
                                var endDate = gantt.date.add(gantt.date.add(date, 3, "month"), -1, "day");
                                return dateToStr(date) + " - " + dateToStr(endDate);
                            }
                        }
                    ]
                },
                {
                    name:"year",
                    scale_height: 50,
                    min_column_width: 30,
                    scales:[
                        {unit: "year", step: 1, format: "%Y"}
                    ]
                }
            ]
        };
        
        gantt.ext.zoom.init(zoomConfig);
        gantt.ext.zoom.setLevel("week");
        
        gantt.plugins({
            tooltip: true
        });
        gantt.attachEvent("onGanttReady", function(){
            var tooltips = gantt.ext.tooltips;
            tooltips.tooltip.setViewport(gantt.$task_data);
        });
        
        gantt.config.columns = [
            {name:"text", label:"Job Name",align: "center"},
            {name:"start_date", label:"Start Date", align: "center"},
            {name:"end_date",   label:"End Date",   align: "center" ,width:"100" }                       
        ];
        gantt.init("gantt_here", new Date(2020,01, 01), new Date(2021,01, 01));
        gantt.parse(demo_tasks1);
        
    }   */
    
})