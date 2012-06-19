<%@ Page %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Vögel</title>

    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />

    <!-- <link rel="apple-touch-icon" href="iphon_tetris_icon.png"/> -->
    <!-- <link rel="apple-touch-startup-image" href="startup.png" /> -->
    <link href="Content/jquery.mobile-1.1.0.min.css" rel="stylesheet" type="text/css" />

    <script src="Scripts/jquery-1.6.4.min.js" type="text/javascript"></script>
    <script src="Scripts/jquery.mobile-1.1.0.min.js" type="text/javascript"></script>
    <script src="Scripts/data.js" type="text/javascript"></script>
    <script type="text/javascript">

function showVoegel(urlObj, options)
{
    var items = Voegel;

    var title = "Vögel";
    var navbar = "#voegel";
    var gruppe = urlObj.hash.match(/[?|&]gruppe=(.+?)(&|$)/);
    if(gruppe)
    {
        title = gruppe[1];
        navbar = "#gruppen";
        items = items.filter(function (el) { return el.Gruppe == title; });
    }
    var gebiet = urlObj.hash.match(/[?|&]gebiet=(.+?)(&|$)/);
    if (gebiet)
    {
        title = gebiet[1];
        navbar = "#gebiet";
        items = items.filter(function (el) { return el.Lebensraum.indexOf(title) >= 0; });
    }

    var $page = $("#voegel");

    // set header
    var $header = $page.children(":jqmData(role=header)");
    $header.find("h1").html(title);
        
    // set content
	var markup = "<ul data-role='listview' data-theme='g' data-filter='true' data-filter-placeholder='Suchen' >";        
    for (var i = 0; i < items.length; i++)
    {
        var item = items[i];
        markup += "<li><a href='#vogel?name=" + item.Name + "' data-transition='slide'>" + item.Name + "</a></li>";
    }
    markup += "</ul>";

    var $content = $page.children(":jqmData(role=content)");
    $content.html(markup);

    $page.page();
    $content.find(":jqmData(role=listview)").listview();

    options.dataUrl = urlObj.href;
    $.mobile.changePage($page, options);

    // footer
    var $footer = $page.children(":jqmData(role=footer)");
    $footer.find('a').removeClass("ui-btn-active"); 
    $footer.find('a[href="' + navbar + '"]').addClass("ui-btn-active");
}

function showVogel(urlObj, options)
{
    var name = urlObj.hash.match(/[?|&]name=(.+?)(&|$)/);

    var item = Voegel.filter(function (el) { return el.Name == name[1]; })[0];
    
    var $page = $("#vogel");

    var $header = $page.children(":jqmData(role=header)");
    $header.find("h1").html(item.Name);

    var $content = $page.children(":jqmData(role=content)");    
    $content.find('img[id="detailBild"]').attr("src", "Assets/" + item.Bilder[0].Source);
    $content.find('div[id="detailGruppe"]').html(item.Gruppe);
    $content.find('div[id="detailLebensraum"]').html(item.Lebensraum);
    $content.find('div[id="detailLaenge"]').html(item.Laenge);

    $page.page();    

    options.dataUrl = urlObj.href;
    $.mobile.changePage($page, options);
}

$(document).bind("pagebeforechange", function (e, data)
{
    if(typeof data.toPage === "string")
    {
        var u = $.mobile.path.parseUrl(data.toPage);
        if(u.hash.search(/^#voegel/) !== -1)
        {
            showVoegel(u, data.options);
            e.preventDefault();
        }
        else if(u.hash.search(/^#vogel/) !== -1)
        {
            showVogel(u, data.options);
            e.preventDefault();
        }        
    }
});

$(document).ready(function()
{
    if (document.location.hash == "") document.location.hash = "#voegel";

    // init gruppen
    var $page = $("#gruppen");

    var markup = "<ul data-role='listview' data-theme='g' >";
    for (var i = 0; i < Gruppen.length; i++)
    {
        var gruppe = Gruppen[i];
        markup += "<li><a href='#voegel?gruppe=" + gruppe  + "' data-transition='slide'>" + gruppe + "</a></li>";
    }
    markup += "</ul>";

    var $content = $page.children(":jqmData(role=content)");
    $content.html(markup);

    $page.page();
    $content.find(":jqmData(role=listview)").listview();

    // init lebensraeume
    $page = $("#gebiete");

    markup = "<ul data-role='listview' data-theme='g' >";
    for (i = 0; i < Lebensraeume.length; i++)
    {
        var lebensraum = Lebensraeume[i];
        markup += "<li><a href='#voegel?gebiet=" + lebensraum + "' data-transition='slide'>" + lebensraum + "</a></li>";
    }
    markup += "</ul>";

    $content = $page.children(":jqmData(role=content)");
    $content.html(markup);

    $page.page();
    $content.find(":jqmData(role=listview)").listview();
});
    </script>
</head>
<body>
    <div data-role="page" id="voegel">
        <div data-role="header" data-position="fixed" data-theme="b">
            <h1>Vögel</h1>
        </div>
        
        <div data-role="content">          

        </div>

        <div data-role="footer" data-position="fixed">
            <div data-role="navbar">
		        <ul>
			        <li><a href="#voegel" class="ui-btn-active ui-state-persist">Vögel</a></li>
			        <li><a href="#gruppen">Gruppen</a></li>
			        <li><a href="#gebiete">Gebiete</a></li>                    
		        </ul>
	        </div>

        </div>
    </div>

    <div data-role="page" id="gruppen">
        <div data-role="header" data-position="fixed" data-theme="b">
            <h1>Gruppen</h1>
        </div>
        
        <div data-role="content">          

        </div>

        <div data-role="footer" data-position="fixed">
            <div data-role="navbar">
		        <ul>
			        <li><a href="#voegel">Vögel</a></li>
			        <li><a href="#gruppen" class="ui-btn-active ui-state-persist">Gruppen</a></li>
			        <li><a href="#gebiete">Gebiete</a></li>                    
		        </ul>
	        </div>

        </div>
    </div>

    <div data-role="page" id="gebiete">
        <div data-role="header" data-position="fixed" data-theme="b">
            <h1>Lebensräume</h1>
        </div>
        
        <div data-role="content">          

        </div>

        <div data-role="footer" data-position="fixed">
            <div data-role="navbar">
		        <ul>
			        <li><a href="#voegel">Vögel</a></li>
			        <li><a href="#gruppen">Gruppen</a></li>
			        <li><a href="#gebiete" class="ui-btn-active ui-state-persist">Gebiete</a></li>                    
		        </ul>
	        </div>

        </div>
    </div>
     
      <div data-role="page" id="vogel">
        <div data-role="header" data-position="fixed" data-theme="b">
            <h1>Vogel</h1>
        </div>
        
        <div data-role="content">
            <div class="ui-grid-solo">
        	    <div class="ui-block-a"><img id="detailBild" alt="" style="width: 100%"/></div>
            </div>

            <div class="ui-grid-a">
	            <div class="ui-block-a">Gruppe</div>
	            <div class="ui-block-b" id="detailGruppe"></div>	   
	            <div class="ui-block-a">Lebensraum</div>
	            <div class="ui-block-b" id="detailLebensraum"></div>	   
	            <div class="ui-block-a">Länge(cm)</div>
	            <div class="ui-block-b" id="detailLaenge"></div>	   
            </div>
        </div>

        <div data-role="footer" data-position="fixed">
            <div data-role="navbar">
		        <ul>
			        <li><a href="#voegel">Vögel</a></li>
			        <li><a href="#gruppen">Gruppen</a></li>
			        <li><a href="#gebiete">Gebiete</a></li>                    
		        </ul>
	        </div>

        </div>
    </div>

</body>
</html>
