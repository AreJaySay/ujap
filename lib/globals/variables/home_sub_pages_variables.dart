import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

int currentindex = 0;
bool isCollapsed = true;
PanelController events_open_filter = new PanelController();
bool showticket = false;
bool floating_action = false;
bool pastTicketEvents = false;
bool pastTicketMatches = false;

var matchTime = "";
var matchDate = "";

PageController middleController;
