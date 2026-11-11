package org.deeptimeline.app
import android.content.Context
import org.json.JSONArray
import org.json.JSONObject
const val ICS_TRANSFER_ID="IcsTransfer_v20261111T042253Z"
object IcsTransfer{fun preview(context:Context,raw:String,existing:List<TimelineEvent>):List<TransferEntry>{val imported=IcsImport.parse(raw);val items=JSONArray();for(item in imported){val row=JSONObject().put("name",item.title).put("date",item.date).put("time",item.time).put("mode",item.mode);if(item.zone.isNotBlank())row.put("zone",item.zone);if(item.id.isNotBlank())row.put("uuid",item.id);items.put(row)};val data=JSONObject().put("format","deep-timeline").put("version",1).put("events",items);return EventJson.parse(context,data.toString(),existing).mapIndexed{i,entry->val item=imported[i];val extra=if(item.note.isBlank())"" else " · ${item.note}";if(item.error.isBlank())entry.copy(detail=entry.detail+extra) else entry.copy(detail=entry.detail+extra,event=null,status="INVALID: ${item.error}",defaultSelected=false)}}}
