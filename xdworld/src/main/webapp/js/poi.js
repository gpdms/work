/*********************************************************
 *	엔진파일 로드 후 Module 객체가 생성되며,
 *  Module 객체를 통해 API 클래스에 접근 할 수 있습니다. 
 *	 - Module.postRun : 엔진파일 로드 후 실행할 함수를 연결합니다.
 *	 - Module.canvas : 지도를 표시할 canvas 엘리먼트를 연결합니다.
 *********************************************************/
 
var Module = {
	TOTAL_MEMORY: 256*1024*1024,
	postRun: [init],
	canvas: (function() {
		
		// Canvas 엘리먼트 생성
		var canvas = document.createElement('canvas');
		
		// Canvas id, Width, height 설정
		canvas.id = "canvas";
		canvas.width="calc(100%)";
		canvas.height="100%";
		
		// Canvas 스타일 설정
		canvas.style.position = "fixed";
		canvas.style.top = "0px";
		canvas.style.left = "0px";

		// canvas 이벤트 설정
		canvas.addEventListener("contextmenu", function(e){
			e.preventDefault();
		});
		
		canvas.onmouseup = function(){
			// Point Input 상태일 경우 클릭 위치에서 Point 객체 생성
			if (Module.XDGetMouseState() == 21){
				createPointObject();
				console.log("클릭이벤트되고있는중!");

			}
		};
		
		// 생성한 Canvas 엘리먼트를 body에 추가합니다.
		document.body.appendChild(canvas);
		
		return canvas;
		
	})()
};

/*********************************************************
 * 엔진 파일을 로드합니다.
 * 파일은 asm.js파일, html.mem파일, js 파일 순으로 로드하며,
 * 로드 시 버전 명(engineVersion)을 적용합니다.
 *********************************************************/

;(function(){   
	
	// 1. XDWorldEM.asm.js 파일 로드
    var file = "./js/XDWorldEM.asm.js";
	var xhr = new XMLHttpRequest();
	xhr.open('GET', file, true);
	xhr.onload = function() {
	  	
		var script = document.createElement('script');
		script.innerHTML = xhr.responseText;
		document.body.appendChild(script);
	
		// 2. XDWorldEM.html.mem 파일 로드
		setTimeout(function() {
			(function() {
				
           		var memoryInitializer = "./js/XDWorldEM.html.mem";
				var xhr = Module['memoryInitializerRequest'] = new XMLHttpRequest();
			    xhr.open('GET', memoryInitializer, true);
			    xhr.responseType = 'arraybuffer';
			    xhr.onload =  function(){
					
					// 3. XDWorldEM.js 파일 로드
                    var url = "./js/XDWorldEM.js";
					var xhr = new XMLHttpRequest();
					xhr.open('GET',url , true);
					xhr.onload = function(){
					   	var script = document.createElement('script');
					   	script.innerHTML = xhr.responseText;
					   	document.body.appendChild(script);
					};
					xhr.send(null);
				}  
			    xhr.send(null);
			})();	
		}, 1);
	};
	xhr.send(null);

})();



/* 엔진 로드 후 실행할 초기화 함수(Module.postRun) */
function init() {

    // 엔진 초기화 API 호출(필수)
   Module.initialize({
      container: document.getElementById("map"),
      terrain : {
				dem : {
					url : "https://xdworld.vworld.kr",
					name : "dem",
					servername : "XDServer3d",
					encoding : true
				},
				image : {
					url : "https://xdworld.vworld.kr",
					name : "tile_mo_HD",
					servername : "XDServer3d"
				},
			},
      defaultKey : "ezbBD(h2eFCmDQFQd9QpdzDS#zJRdJDm4!Epe(a2EzcbEzb2"
   });
   // 카메라 위치 설정
	Module.getViewCamera().setLocation(new Module.JSVector3D(126.976798, 37.575922, 500.0));
	//카메라 화각 설정
	Module.getViewCamera().setFov(90);
	
	// API 클래스 생성
	initSamplePage();
}

/*********************** 아래부터 API 테스트 영역 입니다 ********************************************/

var GLOBAL = {
	
	LayerList : null,
	Layer : null,
	Map : null,
	
	SelectObject_li : null
};

function initSamplePage() {
	
	// 레이어 리스트 및 새 레이어 생성
	GLOBAL.LayerList = new Module.JSLayerList(true);
	GLOBAL.Layer = GLOBAL.LayerList.createLayer("TestLayer", 6);
	
	// 레이어 속성(편집 여부, 최대 가시범위) 설정
	GLOBAL.Layer.setEditable(true);
	GLOBAL.Layer.setMaxDistance(22000000.0);	
	
	// Input Point 관리를 위한 Map 객체 로드
	GLOBAL.Map = new Module.getMap();
	
	// 카메라 이동 설정
	Module.getViewCamera().moveLonLatAlt(127.0273188, 37.4977981, 1000, true);
}


/* Point 객체 추가 함수 */
function createPointObject() {
	
	// Point 오브젝트 생성
	var objectCount = GLOBAL.Layer.getObjectCount();
	var object = Module.createPoint('pointObject'+objectCount);
	
	// 오브젝트 위치 지정
	var positionList = GLOBAL.Map.getInputPointList();
	if (positionList.count == 0) {
		return;
	}
	object.setPosition(positionList.pop());
	
	// Point 텍스트 스타일 설정
	object.setText($id("TX_Text").value);
	var fillColor = new Module.JSColor( parseInt($id("TX_FillColorA").value),
										parseInt($id("TX_FillColorR").value),
										parseInt($id("TX_FillColorG").value),
										parseInt($id("TX_FillColorB").value)
									  );
	var lineColor = new Module.JSColor( parseInt($id("TX_LineColorA").value),
										parseInt($id("TX_LineColorR").value),
										parseInt($id("TX_LineColorG").value),
										parseInt($id("TX_LineColorB").value)
									  );
	object.setFontStyle( $id("TX_FontName").value,
						 parseInt($id("TX_Size").value), 
						 parseInt($id("TX_Weight").value), fillColor, lineColor);
	
	// 생성한 오브젝트를 레이어에 추가
	GLOBAL.Layer.addObject(object, 0);
	
	GLOBAL.Map.clearInputPoint();
	Module.XDRenderData();
	initObjectList();
}


/* 오브젝트 리스트 갱신 함수 */
function initObjectList() {

	var layer = GLOBAL.Layer;
	if (layer == null){
		return;
	}
	
	var objectNum = GLOBAL.Layer.getObjectCount(),	// 현재 추가된 객체 수
		eList = $id("UL_ObjectList")				// 오브젝트 리스트 관리 엘리먼트
		;
	
	// 오브젝트 리스트 초기화
	while (eList.hasChildNodes()) {
		eList.removeChild(eList.firstChild);
	}
	
	// 리스트에 오브젝트 항목 추가
	for (var i=0; i<objectNum; i+=1){
		
		var object = layer.indexAtObject(i);
		if (object == null){
			continue;
		}
		
		var newList = document.createElement("li");
		newList.innerHTML = object.getId();
		newList.index = object.getId();
		newList.onclick = function(e){
			
			// 리스트 클릭 시 색상으로 표시
			if (GLOBAL.SelectObject_li != null){
				GLOBAL.SelectObject_li.style.backgroundColor = "";
			}
			this.style.backgroundColor = "#FFFF00";
			GLOBAL.SelectObject_li = this;
			
			// 오브젝트 삭제 정보 설정
			initObjectProperties(this.innerHTML);
			$id("DV_ObjectProperties").style.display = "block";
		}
		
		eList.appendChild(newList);
	}
	
	$id("DV_ObjectProperties").style.display = "none";
	GLOBAL.SelectObject_li = null;
	$id("TX_ObjectCount").value = objectNum;
}


// /* JSObject형 객체를 JSPoint 타입 객체로 변환 */
// function transformObjectType(_object){
	
	// var oResult = null;
	// if (_object == null){
		// return null;
	// }
	// if (_object.getType() == 'JSPoint'){
		// return new Module.JSPoint(_object);
	// }
	// return null;
// }


/* 객체 정보 출력 */
function initObjectProperties(_objectKey){
	
	var object = GLOBAL.Layer.keyAtObject(_objectKey);
	if (object == null) {
		return;
	}
	
	$id("TX_ObjectKey").value = object.getId();						// 오브젝트 키
	$id("TX_ObjectName").value = object.getName();					// 오브젝트 이름
	
	// 보기, 숨김 설정
	var bVisible = object.getVisible();										
	if (bVisible == Module.JS_VISIBLE_ON) {
		$id("TX_ObjectVisible").value = true;
	} else if (bVisible == Module.JS_VISIBLE_OFF){
		$id("TX_ObjectVisible").value = false;
	}
	
	$id("TX_ObjectDescription").value = object.getDescription();	// 설명 텍스트
	$id("TX_ObjectType").value = object.getType();					// 오브젝트 타입(JSPoint)
	
	// 오브젝트 경위도 위치 및 고도
	var vPosition = object.getPosition();
	$id("TX_ObjectCenterX").value = vPosition.Longitude.toFixed(10);	// 경도(Degree)
	$id("TX_ObjectCenterY").value = vPosition.Latitude.toFixed(10);	// 위도(Degree)
	$id("TX_ObjectCenterZ").value = vPosition.Altitude.toFixed(10);	// 고도(m)

	// 오브젝트 가시 범위
	$id("TX_RangeValueActivate").value = object.getVisibleRangeActivate();	// 가시범위 값 활성화 여부
	$id("TX_RangeValueMin").value = object.getVisibleRangeMin();			// 최소 가시범위
	$id("TX_RangeValueMax").value = object.getVisibleRangeMax();			// 최대 가시범위
	
	// 텍스트 스타일
	$id("TX_ObjectFontName").value = object.getFontName();		// 글꼴 이름
	$id("TX_ObjectFontSize").value = object.getFontSize();		// 텍스트 크기
	$id("TX_ObjectFontWeight").value = object.getFontWeight();	// 텍스트 Weight
	
	// 텍스트 색상
	var fontColor = object.getFontColor();
	$id("TX_ObjectFontColorA").value = fontColor.a;		
	$id("TX_ObjectFontColorR").value = fontColor.r;
	$id("TX_ObjectFontColorG").value = fontColor.g;
	$id("TX_ObjectFontColorB").value = fontColor.b;
	
	// 텍스트 외곽 색상
	var fontOutColor = object.getFontOutColor();
	$id("TX_ObjectFontLineColorA").value = fontOutColor.a;
	$id("TX_ObjectFontLineColorR").value = fontOutColor.r;
	$id("TX_ObjectFontLineColorG").value = fontOutColor.g;
	$id("TX_ObjectFontLineColorB").value = fontOutColor.b;
}


/* 객체 속성 변경 */
function setObjectProperties(_setType){

	if (GLOBAL.SelectObject_li == null){
		return;
	}
	var objectName = GLOBAL.SelectObject_li.innerHTML,
		object = GLOBAL.Layer.keyAtObject(objectName),
		param1 = null,
		param2 = null
		;
	
	switch(_setType){
		
		// 오브젝트 이름 설정
		case 'name':
			param1 = $id("TX_ObjectName").value;
			object.setName(param1);
			break;
			
		// 오브젝트 보기, 숨김 설정
		case 'visible':
			param1 = object.getVisible();
			if (param1 == Module.JS_VISIBLE_ON) {
				param1 = Module.JS_VISIBLE_OFF;
			} else if (param1 == Module.JS_VISIBLE_OFF){
				param1 = Module.JS_VISIBLE_ON;
			} else {
				break;
			}
			object.setVisible(param1);
			break;
		
		// 설명 텍스트 설정
		case 'description':
			param1 = $id("TX_ObjectDescription").value;
			object.setDescription(param1);
			break;
			
		// 가시범위 설정
		case 'visibleRange': 
			param1 = parseFloat($id("TX_RangeValueMin").value);
			param2 = parseFloat($id("TX_RangeValueMax").value);
			object.setVisibleRange(true, param1, param2);
			break;
		
		// 글꼴 이름 설정
		case 'fontName':
			param1 = $id("TX_ObjectFontName").value;
			object.setFontName(param1);
			break;
	}
	
	Module.XDRenderData();
	initObjectProperties(object.getId());
}