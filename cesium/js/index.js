/* jshint esversion: 8, asi: false */
/* global Cesium */
//muj token
const cesiumAccessToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI4ZGZhNzA0YS1jNmEyLTQ4ZmMtYTU2OS1hNGRlMTI3YzVjYmYiLCJpZCI6MzY2Njg2LCJpYXQiOjE3NzMxNDc4MzF9.r1cFVZ_Js7D46zXy-hW7sq9M28aYMz-5dkfQXPVwA9A';
Cesium.Ion.defaultAccessToken = cesiumAccessToken;

// Initializace Cesium Viewer
    const viewer = new Cesium.Viewer('cesiumContainer', {
    infoBox: true,
    selectionIndicator: false,
    timeline: false,
    animation: false,
    baseLayerPicker: false,
    geocoder: false,
    sceneModePicker: false,
       //ortofoto podklad
    baseLayer: Cesium.ImageryLayer.fromProviderAsync(Cesium.IonImageryProvider.fromAssetId(2))
}); 

//nastaveni vychozi polohy kamery
const targetLocation = {
    destination: Cesium.Cartesian3.fromDegrees(17.1403, 49.6750, 600),
    orientation: {
        heading: Cesium.Math.toRadians(0.0),
        pitch: Cesium.Math.toRadians(-35.0),
        roll: 0.0
    },
    duration: 3.0
};

viewer.camera.flyTo(targetLocation);

viewer.homeButton.viewModel.command.beforeExecute.addEventListener(function(e) {
    e.cancel = true;
    viewer.camera.flyTo(targetLocation);  
});

//nacitani vrstev
async function NactiData() {
    try {
        //vlastni teren
        viewer.scene.setTerrain(
            new Cesium.Terrain(
            Cesium.CesiumTerrainProvider.fromIonAssetId(4602921)
            )
        );
        
        viewer.scene.globe.depthTestAgainstTerrain = true;

    
    //Nacteni z Cesium ionu
    // Hillshade
        const hillshadeProvider = await Cesium.IonImageryProvider.fromAssetId(4602897);
        const Hillshade = new Cesium.ImageryLayer(hillshadeProvider, {
            rectangle: hillshadeProvider.rectangle,
            show :false
        });
        viewer.imageryLayers.add(Hillshade);

        //bodove mracno
        const mracno = await Cesium.Cesium3DTileset.fromIonAssetId(4504632);
        viewer.scene.primitives.add(mracno);
        mracno.pointCloudShading.attenuation = true; 

        //tereni deprese
        const deprese = await Cesium.IonResource.fromAssetId(4607670);
        const dataSource = await Cesium.GeoJsonDataSource.load(deprese, {
                /*nastaveni pro vykresleni polygonu jako 2D datove vrstvy
                clampToGround: true, // vykresleni polygonu na povrch
                fill: Cesium.Color.CYAN.withAlpha(0.5), // symbologie JSON */
            stroke: Cesium.Color.TRANSPARENT // Vypnuti hran
        });

        const entities = dataSource.entities.values;
        for (let i = 0; i < entities.length; i++) {
            let entity = entities[i];
            if (entity.polygon) {
                // Vypnuti obrysu polygonu
                entity.polygon.outline = false;

                //zjisteni_rozsahu_lihniste
                let vyskaDna = entity.properties.DNO.getValue();
                let vyskaHladiny = entity.properties.HLADINA.getValue();
                //nastaveni absolutni vyskove hodnoty
                entity.polygon.heightReference = Cesium.HeightReference.NONE;
                entity.polygon.extrudedHeightReference = Cesium.HeightReference.NONE;
                //definice dna a vrchu polygonu
                entity.polygon.height = vyskaDna;
                entity.polygon.extrudedHeight = vyskaHladiny;
                //symbologie polygonu
                entity.polygon.material = Cesium.Color.DEEPSKYBLUE.withAlpha(0.4);

                //uprava pop-up nadpisu
                let cisloTune = "";
                if (entity.properties.id) {
                    cisloTune = entity.properties.id.getValue();
                } else {
                    cisloTune = i + 1;
                }

                entity.name = "Deprese " + cisloTune;
            }
        }
        viewer.dataSources.add(dataSource);

    //prepinac zobrazeni vrstev
        const checkboxDeprese = document.getElementById('toggleDeprese');
        if (checkboxDeprese) {
            checkboxDeprese.addEventListener('change', (event) => {
            dataSource.show = event.target.checked;
            });
        }
        else {
            console.warn("Tlačítko toggleDeprese chybí v HTML!");
        }

        const checkboxMracno = document.getElementById('toggleMracno');
        if (checkboxMracno) {
        checkboxMracno.addEventListener('change', (event) => {
            mracno.show = event.target.checked;
            });
        } else {
            console.warn("Tlačítko toggleMracno chybí v HTML!");
        }

        const checkboxHillshade = document.getElementById('toggleHillshade');
        if (checkboxHillshade) {
            checkboxHillshade.addEventListener('change', (event) => {
            Hillshade.show = event.target.checked;
            });
        }
        else {
            console.warn("Tlačítko toggleHillshade chybí v HTML!");
        }


    } catch (error) {
        console.error("Chyba při načítání dat z Ionu:", error);
    }
}

NactiData();
