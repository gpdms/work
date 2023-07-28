<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!doctype html>
<html>
<head>
	<title>XDWorldEM</title>
	<!-- <link rel="stylesheet" href="style.css"> -->
	<style>
		#map {
			position: absolute;
			width: calc(100%);
			height: calc(100%);
			left: 0px;
			top: 0px;
		}
		#pop-up {
			display: block;
		    position: absolute;
		    left: -5px;
		    z-index: 9;
		    background-color: #FFFFFF;
		    padding: 10px 10px 10px 15px;
		    border-radius: 5px;
		    font-size: 13px;
		    font-weight: bold;
		    opacity: 0.9;
		    width: 300px;
			height: 800px;
		}
	</style>
</head>
<body>
	<div id="map"></div>
	<div id="pop-up">
		<button>POI</button>
		<button>LINE</button>
		<button>POLYGON</button>
		
		<!-- poi -->
		<div>
			<input id="poi_name" type="Text" placeholder="장소명을 입력하세요.">
			<button>생성</button><button>전체삭제</button><br/>
		</div>
	</div>
	
	
	
	<script>
		var initScript = document.createElement('script');
		initScript.src = "./js/init.js";
		document.body.appendChild(initScript);
	
		
		
	var GLOBAL = {
		LayerList : null,
		Layer : null,
		Map : null,
		
		SelectObject_li : null
	}
// 	var poi_name = document.getElementById("poi_name").value;
// 	console.log("poi_name:"+GLOBAL.poi_name);
	
	
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
// 		Module.getViewCamera().moveLonLatAlt(127.0273188, 37.4977981, 1000, true);
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
		
	}
		
		
	
// 	function createPOI() {
		
// 		// POI 오브젝트를 추가 할 레이어 생성
// 		var layerList = new Module.JSLayerList(true);
// 		var layer = layerList.createLayer("POI_TEST", Module.ELT_3DPOINT);
		
	
// 		// Text & image POI
// 		var img = new Image();
// 		img.onload = function() {

// 			// 이미지 로드 후 캔버스에 그리기
// 			var canvas = document.createElement('canvas');
// 			var ctx = canvas.getContext('2d');
// 			canvas.width = img.width;
// 			canvas.height = img.height;
// 			ctx.drawImage(img, 0, 0);
			
// 			// 이미지 POI 생성
// 			var poi_with_text_n_image = Module.createPoint("POI_WITH_IMAGE");
// 			poi_with_text_n_image.setPosition(new Module.JSVector3D(126.92522784212862, 37.52163632683868, 13.357510312460363));
// 			poi_with_text_n_image.setImage(ctx.getImageData(0, 0, this.width, this.height).data, this.width, this.height);
			
// 			// 텍스트 설정
// 			poi_with_text_n_image.setText("클릭한 위치");
			
// 			this.layer.addObject(poi_with_text_n_image, 0);
// 	    };
// 	    img.layer = layer;
// 	    img.src = "./data/pin.png"
// 		//또는 img.src = "/map_practice/data/pin.png"
// 		console.log("경로:"+img.src);
// 		console.log("로딩완료:"+img.complete);
// 	}
 	</script>
	
</body>
</html>
