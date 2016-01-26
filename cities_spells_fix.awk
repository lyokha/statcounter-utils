BEGIN   { FS="\",\""; OFS = FS }

NR < 2  { print; next }

        { switch ($9) {
              case "Krasnoyarskiy Kray":            # Russian Federation
                  $9 = "Krasnoyarsk";
                  break
          }
          switch ($10) {
              case "Tolyatti":                      # Russian Federation
                  $10 = "Togliatti";
                  break
              case "Togliatti":
                  if ($9 == "Sakha")
                      $9 = "Samara";
                  break
              case "Cheliabinsk":
                  $10 = "Chelyabinsk";
                  break
              case "Rostov-na-Donu":
              case "Rostov-na-donu":
                  $10 = "Rostov-on-Don";
                  break
              case "Rostov":
                  if ($9 == "Rostov")
                      $10 = "Rostov-on-Don";
                  break
              case "Nizhni Tagil":
                  $10 = "Nizhniy Tagil";
                  break
              case "Nizhnii Novgorod":
                  $10 = "Nizhniy Novgorod";
                  break
              case "Ramenskoe":
                  $10 = "Ramenskoye";
                  break
              case "Mytishi":
                  $10 = "Mytishchi";
                  break
              case "Khimki":
                  if ($9 == "Moscow City")
                      $9 = "Moskva";
                  break
              case "Zhukovskiy":
                  if ($9 == "Moscow City")
                      $9 = "Moskva";
                  break
              case "Saint-petersburg":
              case "Sankt-peterburg":
              case "Leningrad":
                  $10 = "Saint Petersburg";
                  break
              case "Belebei":
                  $10 = "Belebey";
                  break
              case "Kharkiv":                       # Ukraine
                  $10 = "Kharkov";
                  break
              case "Lvov":
              case "Lwów":
                  $10 = "Lviv";
                  break
              case "Dnipropetrovsk":
              case "Dniepropetrovsk":
                  $10 = "Dnepropetrovsk";
                  break
              case "Luhansk":
                  $10 = "Lugansk";
                  break
              case "Vinnytsya":
                  $10 = "Vinnitsa";
                  break
              case "Cherkasy":
                  $10 = "Cherkassy";
                  break
              case "Chernihiv":
                  $10 = "Chernigov";
                  break
              case "Kremenchuk":
                  $10 = "Kremenchug";
                  break
              case "Zhytomyr":
                  $10 = "Zhitomir";
                  break
              case "Chortkiv":
                  $10 = "Chortkov";
                  break
              case "Kyiv":
                  $10 = "Kiev";
                  break
              case "Zaporozhye":
                  $10 = "Zaporizhzhya";
                  break
              case "Erevan":                        # Armenia
                  $10 = "Yerevan";
                  break
              case "Qostanay":                      # Kazakhstan
                  $10 = "Kostanay";
                  break
              case "Frankfurt":                     # Germany
                  if ($9 == "Hessen")
                      $10 = "Frankfurt Am Main";
                  break
              case "Muenster":
                  $10 = "Münster";
                  break
          }
          print
      }

# They are really different

# Lugansk(oye)   (Zaporizhzhya)
# Sevastopol     (Kaluga)
# Yaroslavl      (Kirov)
# Belgorod       (Bryansk)
# Stavropol      (Samara)
# Samara         (Orel)
# Kirov          (Stavropol')
# Kazan          (Kirov)
# Donetsk        (Rostov)
# Grodno         (Minskaya Voblasts')
# Gomel          (Vitsyebskaya Voblasts')
# Aktobe         (Almaty)

