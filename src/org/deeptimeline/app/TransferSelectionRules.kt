package org.deeptimeline.app
object TransferSelectionRules{fun change(available:BooleanArray,selected:BooleanArray,action:Int){require(available.size==selected.size);for(i in available.indices)selected[i]=available[i]&&when(action){0->true;1->false;else->!selected[i]}};fun count(selected:BooleanArray)=selected.count{it}}
