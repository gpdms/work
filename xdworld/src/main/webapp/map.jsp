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
			<input id="poi_name" type="Text" placeholder="��Ҹ��� �Է��ϼ���.">
			<button>����</button><button>��ü����</button><br/>
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
		
		// ���̾� ����Ʈ �� �� ���̾� ����
		GLOBAL.LayerList = new Module.JSLayerList(true);
		GLOBAL.Layer = GLOBAL.LayerList.createLayer("TestLayer", 6);
		
		// ���̾� �Ӽ�(���� ����, �ִ� ���ù���) ����
		GLOBAL.Layer.setEditable(true);
		GLOBAL.Layer.setMaxDistance(22000000.0);	
		
		// Input Point ������ ���� Map ��ü �ε�
		GLOBAL.Map = new Module.getMap();
		
		// ī�޶� �̵� ����
// 		Module.getViewCamera().moveLonLatAlt(127.0273188, 37.4977981, 1000, true);
	}

	/* Point ��ü �߰� �Լ� */
	function createPointObject() {
		
		// Point ������Ʈ ����
		var objectCount = GLOBAL.Layer.getObjectCount();
		var object = Module.createPoint('pointObject'+objectCount);
		// ������Ʈ ��ġ ����
		var positionList = GLOBAL.Map.getInputPointList();
		if (positionList.count == 0) {
			return;
		}
		object.setPosition(positionList.pop());
		
	}
		
		
	
// 	function createPOI() {
		
// 		// POI ������Ʈ�� �߰� �� ���̾� ����
// 		var layerList = new Module.JSLayerList(true);
// 		var layer = layerList.createLayer("POI_TEST", Module.ELT_3DPOINT);
		
	
// 		// Text & image POI
// 		var img = new Image();
// 		img.onload = function() {

// 			// �̹��� �ε� �� ĵ������ �׸���
// 			var canvas = document.createElement('canvas');
// 			var ctx = canvas.getContext('2d');
// 			canvas.width = img.width;
// 			canvas.height = img.height;
// 			ctx.drawImage(img, 0, 0);
			
// 			// �̹��� POI ����
// 			var poi_with_text_n_image = Module.createPoint("POI_WITH_IMAGE");
// 			poi_with_text_n_image.setPosition(new Module.JSVector3D(126.92522784212862, 37.52163632683868, 13.357510312460363));
// 			poi_with_text_n_image.setImage(ctx.getImageData(0, 0, this.width, this.height).data, this.width, this.height);
			
// 			// �ؽ�Ʈ ����
// 			poi_with_text_n_image.setText("Ŭ���� ��ġ");
			
// 			this.layer.addObject(poi_with_text_n_image, 0);
// 	    };
// 	    img.layer = layer;
// 	    img.src = "./data/pin.png"
// 		//�Ǵ� img.src = "/map_practice/data/pin.png"
// 		console.log("���:"+img.src);
// 		console.log("�ε��Ϸ�:"+img.complete);
// 	}
 	</script>
	
</body>
</html>
