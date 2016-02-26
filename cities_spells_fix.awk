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
              case "Rostov-na-donu":
                  $10 = "Rostov-on-don";
                  break
              case "Rostov":
                  if ($9 == "Rostov")
                      $10 = "Rostov-on-don";
                  break
              case "Sverdlovsk":
                  if ($9 == "Sverdlovsk")
                      $10 = "Yekaterinburg";
                  break
              case "Nizhni Tagil":
                  $10 = "Nizhniy Tagil";
                  break
              case "Tagil":
                  if ($9 == "Tatarstan")
                      $9 = "Sverdlovsk";
                      $10 = "Nizhniy Tagil";
                  break
              case "Nizhnii Novgorod":
                  $10 = "Nizhniy Novgorod";
                  break
              case "Velikiy Novgorod":
                  if ($9 == "Novosibirsk")
                      $9 = "Novgorod";
                  break
              case "Orenburg":
                  if ($9 == "Khabarovsk")
                      $9 = "Orenburg";
                  break
              case "Komsomolsk":
                  if ($9 == "Khabarovsk")
                      $10 = "Komsomolsk-na-amure";
                  break
              case "Yugra":
                  if ($9 == "Vologda" && $12 ~ "Yugra State University")
                      $9 = "Khanty-Mansiy";
                      $10 = "Khanty-Mansiysk";
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
              case "Staryy Oskol":
                  $10 = "Stary Oskol";
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
              case "Lugansk":
                  if ($9 == "Zaporiz'ka Oblast'")
                      $9 = "Luhans'ka Oblast'";
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
              case "Sevastopol":
                  if ($9 == "Kaluga" && $12 == "Lancom Ltd, Russia, Sevastopol")
                      $8 = "Ukraine";
                      $9 = "Krym";
                  break
              case "Mogilev":                       # Belarus
                  $10 = "Mogilëv";
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

# They seem unlikely to be different

#   Yaroslavl      (Kirov)
#   Belgorod       (Bryansk)
#   Stavropol      (Samara)
#   Samara         (Orel)
#   Kirov          (Stavropol')
#   Kazan          (Kirov)

# They must be really different

#   Donetsk        (Rostov)
#   Grodno         (Minskaya Voblasts')
#   Gomel          (Vitsyebskaya Voblasts')
#   Aktobe         (Almaty)

