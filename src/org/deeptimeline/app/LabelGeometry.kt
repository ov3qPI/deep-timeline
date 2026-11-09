package org.deeptimeline.app
import kotlin.math.max
object LabelGeometry{fun gap(ascent:Float,descent:Float,leading:Float,fontSpacing:Float,density:Float):Double{require(density>0f&&descent>ascent&&fontSpacing>0f);return max(descent-ascent+leading,fontSpacing).toDouble()+6.0*density};fun baselineOffset(ascent:Float,descent:Float):Float=-(ascent+descent)*0.5f;fun hitRadius(ascent:Float,descent:Float,density:Float):Double=max((descent-ascent)*0.5f+2f*density,12f*density).toDouble();fun visibleMargin(ascent:Float,descent:Float):Double=max(-ascent,descent).toDouble()}
