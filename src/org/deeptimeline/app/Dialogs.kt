package org.deeptimeline.app
import android.app.Dialog
import android.content.Context
import android.view.Gravity
import android.view.View
import android.view.WindowManager
import android.widget.LinearLayout
import android.widget.ScrollView
fun Context.modal(title:String,content:View):Dialog{val d=Dialog(this);val outer=column();outer.setPadding(dp(12),dp(10),dp(12),dp(10));outer.add(label(title,20f));outer.add(content);d.setContentView(outer);d.window?.setBackgroundDrawableResource(android.R.color.black);d.window?.setLayout(WindowManager.LayoutParams.MATCH_PARENT,WindowManager.LayoutParams.WRAP_CONTENT);return d}
fun Context.choose(title:String,items:List<String>,onChoice:(Int)->Unit){val column=column();var dialog:Dialog?=null;for((i,item)in items.withIndex()){val t=action(item){dialog?.dismiss();onChoice(i)};column.add(t,-1,dp(46))};dialog=modal(title,column);dialog.show();dialog.window?.setLayout((resources.displayMetrics.widthPixels*0.92).toInt(),WindowManager.LayoutParams.WRAP_CONTENT)}
fun Context.confirm(title:String,message:String,yes:()->Unit){val root=column();root.add(label(message,15f));val buttons=row();var dlg:Dialog?=null;buttons.add(action("CANCEL"){dlg?.dismiss()},0,dp(48),1f);buttons.add(action("DELETE"){dlg?.dismiss();yes()},0,dp(48),1f);root.add(buttons);dlg=modal(title,root);dlg.show();dlg.window?.setLayout((resources.displayMetrics.widthPixels*0.92).toInt(),WindowManager.LayoutParams.WRAP_CONTENT)}
