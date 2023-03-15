({
	 afterScriptsLoaded: function(cmp,evt,helper){
          helper.fetchCalenderEvents(cmp);
          helper.getStatusList(cmp,evt,helper);
    }
})