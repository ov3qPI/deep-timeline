package org.deeptimeline.app
import android.content.Context
import android.util.AtomicFile
import java.io.File
object OverwriteBackup{private const val BACKUP_NAME="last_pre_overwrite.json";fun available(context:Context)=File(context.filesDir,BACKUP_NAME).isFile;fun read(context:Context):String=AtomicFile(File(context.filesDir,BACKUP_NAME)).openRead().use{it.reader(Charsets.UTF_8).readText()};fun save(context:Context,events:List<TimelineEvent>){val file=AtomicFile(File(context.filesDir,BACKUP_NAME));var output:java.io.FileOutputStream?=null;try{output=file.startWrite();output.write(EventJson.export(events).toByteArray(Charsets.UTF_8));file.finishWrite(output)}catch(e:Exception){if(output!=null)file.failWrite(output);throw e}}}
