if (serviceable == 1){
	var downlink = func(key){
		if(contains(onBoard, key)){
			ground.key = onBoard.key;
		}
	}
	
	var uplink = func(key){
		if(contains(ground, key)){
			onBoard.key = ground.key;
		}
	}
	
	var ground{}；
	var onBoard{};
}
