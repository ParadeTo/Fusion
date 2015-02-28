using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ESRI.ArcGIS.Carto;
using ESRI.ArcGIS.Display;
using ESRI.ArcGIS.Geodatabase;

namespace Fusion
{
    class BandCombinationShow
    {
        /// <summary>
        /// 根据单波段拉伸渲染
        /// </summary>
        /// <param name="rasterDataset">栅格数据集</param>
        /// <param name="graypos">第几波段</param>
        /// <param name="stretchType">拉伸方式</param>
        /// <param name="pFromColor">fromColor</param>
        /// <param name="pToColor">toColor</param>
        /// <returns></returns>
        public static IRasterRenderer StretchRenderer(ESRI.ArcGIS.Geodatabase.IRasterDataset rasterDataset, int graypos,
            esriRasterStretchTypesEnum stretchType, IRgbColor pFromColor,IRgbColor pToColor)
        {
            try
            {
                //Create the color ramp.
                IAlgorithmicColorRamp colorRamp = new AlgorithmicColorRampClass();
                colorRamp.Size = 255;
                colorRamp.FromColor = pFromColor;
                colorRamp.ToColor = pToColor;
                bool createColorRamp;
                colorRamp.CreateRamp(out createColorRamp);
                //Create a stretch renderer.
                IRasterStretchColorRampRenderer stretchRenderer = new
                RasterStretchColorRampRendererClass();

                IRasterRenderer rasterRenderer = (IRasterRenderer)stretchRenderer;
                //Set the renderer properties.
                IRaster raster = rasterDataset.CreateDefaultRaster();
                rasterRenderer.Raster = raster;
                rasterRenderer.Update();
                stretchRenderer.BandIndex = graypos;
                stretchRenderer.ColorRamp = colorRamp;
                //Set the stretch type.
                IRasterStretch pRasterStretch = (IRasterStretch)rasterRenderer;
                pRasterStretch.StretchType = stretchType;
                pRasterStretch.StandardDeviationsParam = 2;
                return rasterRenderer;
            }
            catch
            {
                return null;
            }
        }
    }
}
