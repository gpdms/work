<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!doctype html>
<html>
<head>
	<title>[EGIS] Text Point Object</title>
	<link rel="stylesheet" href="./css/poi.css">
</head>
<body>
	<script>
		var initScript = document.createElement('script');
		initScript.src = "./js/poi.js";
		document.body.appendChild(initScript);
		
		function $id(_elementName){
			return document.getElementById(_elementName);
		}

	</script>
	
	
	
	<div id="map"></div>
	<div id="DV_ContentWrap" style="top:5px;" onmouseover="Module.XDIsMouseOverDiv(true);" onmouseout="Module.XDIsMouseOverDiv(false);">
		
		[Mouse Mode]
		<form>
		  <input type="radio" name="mouseMode" onclick="Module.XDSetMouseState(1);" checked> 지도 이동
		  <input type="radio" name="mouseMode" onclick="Module.XDSetMouseState(21);"> Point 객체 입력<br/><br/>
		</form> 
		
		[Input Text Option]
		<table>
			<tr><th>Option</th><th>Value</th></tr>
			<tr>
				<th>Text</th>
				<th><input type="text" class="TX_Option" id="TX_Text" value="테스트 입력 Point"></th>
			</tr>
			<tr>
				<th>Font Name</th>
				<th><input type="text" class="TX_Option" id="TX_FontName" value="맑은 고딕"></th>
			</tr>
			<tr>
				<th>Fill Color</th>
				<th>
					ARGB(
					<input type="text" class="TX_Color" id="TX_FillColorA" value="255">,
					<input type="text" class="TX_Color" id="TX_FillColorR" value="255">,
					<input type="text" class="TX_Color" id="TX_FillColorG" value="255">,
					<input type="text" class="TX_Color" id="TX_FillColorB" value="255">)
				</th>
			</tr>
			<tr>
				<th>Line Color</th>
				<th>
					ARGB(
					<input type="text" class="TX_Color" id="TX_LineColorA" value="255">,
					<input type="text" class="TX_Color" id="TX_LineColorR" value="0">,
					<input type="text" class="TX_Color" id="TX_LineColorG" value="0">,
					<input type="text" class="TX_Color" id="TX_LineColorB" value="0">)
				</th>
			</tr>
			<tr>
				<th>Size(Weight)</th>
				<th>
					<input type="text" class="TX_FontSize" id="TX_Size" value="15">px 
					(<input type="text" class="TX_FontSize" id="TX_Weight" value="600">)
				</th>
			</tr>
		</table>
		<br/>

		[Object List]
		<div id="DV_ObjectListWrap">
			<ul id="UL_ObjectList"></ul>
		</div>
		Object Count
		<input type="text" id="TX_ObjectCount" class="TX_Option" value="0"><br/>

	</div>
	
	<div id="DV_ObjectProperties" onmouseover="Module.XDIsMouseOverDiv(true);" onmouseout="Module.XDIsMouseOverDiv(false);">
		Object Properties<br/>
		<table>
			<tr>
				<th>Option</th>
				<th colspan='2'>Value</th>
			</tr>
			<tr>
				<td>Key</td>
				<td colspan="2"><input type="text" id="TX_ObjectKey" style="width:218px;text-align:center;"></td>
			</tr>
			<tr>
				<td>Name</td>
				<td><input type="text" id="TX_ObjectName" style="width:159px;text-align:center;"></td>
				<td><input type="button" value="Set" style="width:55px;" onClick="setObjectProperties('name')"></td>
			</tr>
			<tr>
				<td>Visible</td>
				<td><input type="text" id="TX_ObjectVisible" style="width:159px;text-align:center;"></td>
				<td><input type="button" value="Toggle" style="width:55px;" onClick="setObjectProperties('visible')"></td>
			</tr>
			<tr>
				<td>Description</td>
				<td><input type="text" id="TX_ObjectDescription" style="width:159px;text-align:center;"></td>
				<td><input type="button" value="Set" style="width:55px;" onClick="setObjectProperties('description')"></td>
			</tr>
			<tr>
				<td>Type</td>
				<td colspan='2'><input type="text" id="TX_ObjectType" style="width:218px;text-align:center;" readonly></td>
			</tr>
			<tr>
				<td>Center</td>
				<td colspan='2'>
					<ul class="UL_ObjectSubProperties">
						<li>X <input type="text" id="TX_ObjectCenterX" style="width:204px;text-align:center;" readonly></li>
						<li>Y <input type="text" id="TX_ObjectCenterY" style="width:205px;text-align:center;" readonly></li>
						<li>Z <input type="text" id="TX_ObjectCenterZ" style="width:204px;text-align:center;" readonly></li>
					</ul>
				</td>
			</tr>
			<tr>
				<td>Visible<br/>Range</td>
				<td>
					<ul class="UL_ObjectSubProperties">
						<li>Set <input type="text" id="TX_RangeValueActivate" style="width:134px;text-align:center;" readonly></li>
						<li>Min <input type="text" id="TX_RangeValueMin" style="width:129px;text-align:center;"></li>
						<li>Max <input type="text" id="TX_RangeValueMax" style="width:127px;text-align:center;"></li>
					</ul>
				</td>
				<td><input type="button" value="Set" style="width:55px;height:63px;" onClick="setObjectProperties('visibleRange')"></td>
			</tr>
			<tr>
				<td>Font Name</td>
				<td colspan='2'><input type="text" id="TX_ObjectFontName" style="width:218px;text-align:center;" readonly></td>
			</tr>
			<tr>
				<td>Font Size</td>
				<td colspan='2'><input type="text" id="TX_ObjectFontSize" style="width:218px;text-align:center;" readonly></td>
			</tr>
			<tr>
				<td>Font Weight</td>
				<td colspan='2'><input type="text" id="TX_ObjectFontWeight" style="width:218px;text-align:center;" readonly></td>
			</tr>
			<tr>
				<th>Font Color</th>
				<th colspan='2'>
					ARGB(
					<input type="text" class="TX_Color" id="TX_ObjectFontColorA" readonly>,
					<input type="text" class="TX_Color" id="TX_ObjectFontColorR" readonly>,
					<input type="text" class="TX_Color" id="TX_ObjectFontColorG" readonly>,
					<input type="text" class="TX_Color" id="TX_ObjectFontColorB" readonly>)
				</th>
			</tr>
			<tr>
				<th>Font OutLine Color
				</th>
				<th colspan='2'>
					ARGB(
					<input type="text" class="TX_Color" id="TX_ObjectFontLineColorA" readonly>,
					<input type="text" class="TX_Color" id="TX_ObjectFontLineColorR" readonly>,
					<input type="text" class="TX_Color" id="TX_ObjectFontLineColorG" readonly>,
					<input type="text" class="TX_Color" id="TX_ObjectFontLineColorB" readonly>)
				</th>
			</tr>
		</table>
	</div>
	
</body>
</html>



