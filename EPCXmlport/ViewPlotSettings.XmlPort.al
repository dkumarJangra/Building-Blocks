xmlport 50010 "View Plot Settings"
{
    UseDefaultNamespace = true;

    schema
    {
        textelement(Root)
        {
            tableelement(tempplotsetting; "Plot Configuration Setting")
            {
                MaxOccurs = Once;
                XmlName = 'PlotConfigurationSetting';
                UseTemporary = false;
                fieldelement(ProjectID; TempPlotSetting.ProjectID)
                {
                }
                fieldelement(FontSize; TempPlotSetting.DivFontSize)
                {
                }
                fieldelement(BorderWidth; TempPlotSetting.DivBordeWidth)
                {
                }
                fieldelement(FontWeight; TempPlotSetting.FontWeight)
                {
                }
                fieldelement(FontColor; TempPlotSetting.FontColor)
                {
                }
                fieldelement(AvailablePlotColor; TempPlotSetting.AvilablePlotColor)
                {
                }
                fieldelement(BookedPlotColor; TempPlotSetting.BookedPlotColor)
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }
}

