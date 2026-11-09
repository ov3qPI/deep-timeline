package org.deeptimeline.app
import android.app.Activity
import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Path
import android.graphics.RectF
import android.graphics.drawable.GradientDrawable
import android.view.Gravity
import android.view.View
import android.widget.EditText
import android.widget.LinearLayout
import android.widget.TextView
const val RED:Int=Color.RED
const val BLACK:Int=Color.BLACK
fun Context.dp(n:Float):Float=n*resources.displayMetrics.density
fun Context.dp(n:Int):Int=(n*resources.displayMetrics.density+0.5f).toInt()
fun Context.border():GradientDrawable=GradientDrawable().apply{setColor(BLACK);setStroke(dp(1),RED);setCornerRadius(dp(3f))}
fun Context.label(text:String,size:Float=16f):TextView=TextView(this).apply{this.text=text;setTextColor(RED);textSize=size;gravity=Gravity.CENTER_VERTICAL;setPadding(dp(8),dp(5),dp(8),dp(5));includeFontPadding=false}
fun Context.field(value:String,hintValue:String):EditText=EditText(this).apply{setText(value);hint=hintValue;setTextColor(RED);setHintTextColor(RED);setSingleLine(true);textSize=16f;setSelectAllOnFocus(false);background=border();setPadding(dp(10),dp(9),dp(10),dp(9))}
fun Context.column():LinearLayout=LinearLayout(this).apply{orientation=LinearLayout.VERTICAL;setBackgroundColor(BLACK)}
fun Context.row():LinearLayout=LinearLayout(this).apply{orientation=LinearLayout.HORIZONTAL;gravity=Gravity.CENTER_VERTICAL;setBackgroundColor(BLACK)}
fun LinearLayout.add(view:View,width:Int=-1,height:Int=-2,weight:Float=0f){addView(view,LinearLayout.LayoutParams(width,height,weight))}
fun Context.action(text:String,callback:()->Unit):TextView=label(text,15f).apply{background=border();gravity=Gravity.CENTER;setOnClickListener{callback()}}
class Glyph(context:Context,val kind:String):View(context){private val p=Paint(3).apply{color=RED;strokeWidth=context.dp(2f);strokeCap=Paint.Cap.ROUND;strokeJoin=Paint.Join.ROUND;style=Paint.Style.STROKE};init{isClickable=true;isLongClickable=true;contentDescription=kind;setBackgroundColor(BLACK)};override fun onDraw(c:Canvas){super.onDraw(c);val x=width/2f;val y=height/2f;val r=context.dp(10f);p.color=RED;p.strokeWidth=context.dp(2f);p.style=Paint.Style.STROKE;when(kind){"plus"->{c.drawLine(x-r,y,x+r,y,p);c.drawLine(x,y-r,x,y+r,p)};"now"->{c.drawCircle(x,y,r*0.7f,p);c.drawLine(x-r*1.3f,y,x-r*0.55f,y,p);c.drawLine(x+r*0.55f,y,x+r*1.3f,y,p);c.drawLine(x,y-r*1.3f,x,y-r*0.55f,p);c.drawLine(x,y+r*0.55f,x,y+r*1.3f,p)};"scale"->{c.drawRect(x-r*0.9f,y-r,x+r*0.9f,y+r,p);c.drawLine(x-r*0.9f,y-r*0.4f,x+r*0.9f,y-r*0.4f,p);c.drawLine(x-r*0.3f,y-r*0.9f,x-r*0.3f,y-r*0.5f,p);c.drawLine(x+r*0.3f,y-r*0.9f,x+r*0.3f,y-r*0.5f,p)};"trash"->{c.drawRect(x-r*0.62f,y-r*0.5f,x+r*0.62f,y+r,p);c.drawLine(x-r*0.8f,y-r*0.65f,x+r*0.8f,y-r*0.65f,p);c.drawLine(x-r*0.28f,y-r*0.95f,x+r*0.28f,y-r*0.95f,p)};"gps"->{val path=Path();path.moveTo(x,y+r);path.cubicTo(x-r*1.6f,y-r*0.25f,x-r*0.6f,y-r*1.3f,x,y-r*1.3f);path.cubicTo(x+r*0.6f,y-r*1.3f,x+r*1.6f,y-r*0.25f,x,y+r);c.drawPath(path,p);c.drawCircle(x,y-r*0.3f,r*0.23f,p)};"info"->{c.drawCircle(x,y,r,p);c.drawPoint(x,y-r*0.45f,p);c.drawLine(x,y-r*0.05f,x,y+r*0.5f,p)};"transfer"->{c.drawLine(x-r,y-r*0.55f,x+r,y-r*0.55f,p);c.drawLine(x+r,y-r*0.55f,x+r*0.45f,y-r,p);c.drawLine(x+r,y-r*0.55f,x+r*0.45f,y-r*0.1f,p);c.drawLine(x+r,y+r*0.55f,x-r,y+r*0.55f,p);c.drawLine(x-r,y+r*0.55f,x-r*0.45f,y+r,p);c.drawLine(x-r,y+r*0.55f,x-r*0.45f,y+r*0.1f,p)};"close"->{c.drawLine(x-r,y-r,x+r,y+r,p);c.drawLine(x+r,y-r,x-r,y+r,p)};else->c.drawCircle(x,y,r,p)}}}
