using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Script.Serialization;
using HtmlAgilityPack;

namespace Downloader
{
	class Program
	{
		const string IMAGES_FOLDER = "images";
		const string THUMBS_FOLDER = "thumbs";

		static void Main()
		{
			//Download();
			//CreateThumbs();
		}

		static void Download()
		{
			List<Vogel> voegel = new List<Vogel>();
			
			Directory.CreateDirectory(IMAGES_FOLDER);

			Uri baseUri = new Uri("http://www.vogelwarte.ch");

			HtmlWeb web = new HtmlWeb();

			Uri queryUri = new Uri(baseUri, "voegel-der-schweiz.html?keyword=&mode=name%2CnameL&showPage=0&length=0&lang=de&exampleSearch=0");
			Console.WriteLine(queryUri);
			var docQuery = web.Load(queryUri.ToString());
			foreach(var elEntry in docQuery.DocumentNode.SelectNodes("//table[@class=\"list\"]/tr[@class=\"listEntry\"]/td/h3/a"))
			{
				Uri uriEntry = new Uri(baseUri, Decode(elEntry.Attributes["href"].Value));
				Console.WriteLine(uriEntry);
				var docEntry = web.Load(uriEntry.ToString());

				var nodeDetail = docEntry.DocumentNode.SelectSingleNode("//div[@id=\"birdDetail\"]");

				Vogel vogel = new Vogel {
					Name = Decode(elEntry.InnerText),
					Gruppe =  Decode(nodeDetail.SelectSingleNode("//td[strong/text()=\"Vogelgruppe:\"]").LastChild.InnerText),
					Lebensraum = Decode(nodeDetail.SelectSingleNode("//td[strong/text()=\"Lebensraum:\"]").LastChild.InnerText),
					Laenge = Decode(nodeDetail.SelectSingleNode("//td[strong/text()=\"Länge (cm):\"]").LastChild.InnerText),				
					Bilder = nodeDetail.SelectNodes("//div[@id=\"gallery\"]/div/img").Select(nodeImg => new Bild
																												{
																													Titel = Decode(nodeImg.Attributes["title"].Value),
																													Source = new Uri(baseUri, Decode(nodeImg.Attributes["src"].Value)).ToString()
																												}).ToArray()
				};

				voegel.Add(vogel);

				foreach(var bild in vogel.Bilder)
				{
					using(var client = new WebClient())
					{
						Console.WriteLine(bild.Source);

						string strFile =  Path.GetFileName(bild.Source);
						client.DownloadFile(bild.Source, IMAGES_FOLDER + "/" + strFile);
						bild.Source = strFile;
					}
				}
			}

			JavaScriptSerializer serializer = new JavaScriptSerializer();			
			using(StreamWriter sr = File.CreateText("data.js"))
			{
				sr.Write("var Voegel = ");
				sr.Write(serializer.Serialize(voegel.OrderBy(v => v.Name)));
				sr.Write(";\r\nvar Gruppen = ");
				sr.Write(serializer.Serialize(voegel.Select(v => v.Gruppe).Distinct().OrderBy(g => g)));
				sr.Write(";\r\nvar Lebensraeume = ");
				sr.Write(serializer.Serialize(voegel.SelectMany(v => v.Lebensraum.Split(',').Select(l => l.Trim())).Distinct().OrderBy(l => l)));
				sr.Write(";");
			}
		}

		static void CreateThumbs()
		{
			Directory.CreateDirectory(THUMBS_FOLDER);

			foreach(var strFile in Directory.GetFiles(IMAGES_FOLDER))
			{
				Console.WriteLine(strFile);

				Image img = Image.FromFile(strFile);
				Image thumbnailImage = img.GetThumbnailImage(120, 80, () => true, IntPtr.Zero);
				string strThumbnailFile = THUMBS_FOLDER + "/" + Path.GetFileName(strFile);
				thumbnailImage.Save(strThumbnailFile, img.RawFormat);
			}
		}

		static string Decode(string str)
		{
			return HttpUtility.HtmlDecode(str).Trim();
		}
	}
}

