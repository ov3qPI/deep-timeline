package org.deeptimeline.app
data class VerticalClockPlacement(val pivotX:Float,val pivotY:Float,val textX:Float,val baselineY:Float)
object VerticalClockLayout{fun place(axisX:Float,viewHeight:Float,gutterOffset:Float,textWidth:Float,ascent:Float,descent:Float):VerticalClockPlacement{require(viewHeight>0f&&textWidth>=0f);val px=axisX-gutterOffset;val py=viewHeight*0.5f;return VerticalClockPlacement(px,py,px-textWidth*0.5f,py-(ascent+descent)*0.5f)}}
