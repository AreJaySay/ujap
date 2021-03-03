import 'package:flutter/material.dart';

bool showcalendar = false;
bool events_filter_open = false;
double scrollPosition;
bool hideFloatingbutton = false;
bool myEventFloatingbutton = false;
bool eventsSearch = false;
TextEditingController searchfilter = new TextEditingController();
var events_tabbarview_index = "";
double events_attended = 0;
double events_allocation = 0;
bool history_eventsmatches = false;
bool hideButtons = false;

bool showCloseButton = false;

// FILTER SEARCH
var searchbox_filter = "";
int convertedDate_filter = 0;
int convertedDate_filter_to = 99999999999;
var status_data = "";
var view_data = "";