function suspicious_repl(t, a, r, c, nr, nc, m)
{
    if (warn_suspicious) {
        if (suspicious_count++ == 0)
            printf "Suspicious locations replaced:\n%s\n",
                delim > "/dev/stderr";
        printf "%s | %+15s | %s%s (%s)  ->  %s (%s)\n",
                t,       a,  m,$c, $r,      nc, nr > "/dev/stderr"
    }
    $r = nr;
    $c = nc
}

function suspicious_repl2(t, a, s, r, c, ns, nr, nc, m)
{
    if (warn_suspicious) {
        if (suspicious_count++ == 0)
            printf "Suspicious locations replaced:\n%s\n",
                delim > "/dev/stderr";
        printf "%s | %+15s | %s%s (%s / %s)  ->  %s (%s / %s)\n",
                t,       a,  m,$c, $r,  $s,      nc, nr,  ns > "/dev/stderr"
    }
    $s = ns;
    $r = nr;
    $c = nc
}

function delete_spam()
{
    if (warn_spam) {
        ++spam_count
    }
    next
}

BEGIN   { FS="\",\""; OFS = FS;
          # warn_suspicious and warn_spam
          # are expected to be passed via command line
          warn_suspicious = warn_suspicious ~ /^y(es)?$/;
          warn_spam = warn_spam ~ /^y(es)?$/;
          suspicious_count = 0;
          spam_count = 0;
          delim = "--------"
          delim2 = "  ----  "
        }

# print header
NR < 2  { print; next }

# delete spam
$17 ~ "\\<seo\\>" { delete_spam() }
$8 == "Vietnam" && $1 ~ "^\"2018" &&
   ($15 ~ "showComment" || $17 ~ "showComment") { delete_spam() }

#fix spells
        { switch ($9) {
              case "Krasnoyarskiy Kray":            # Russian Federation
                  $9 = "Krasnoyarsk";
                  break
              case "Irkutsk": 
                  if ($12 ~ "Tele2 Russia .* \\(MSK\\)$")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                    "Moscow City", "Moscow", $12 "  >>  ");
                  else if ($12 ~ "Tele2 Russia .* \\(SPB\\)$")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                    "Saint Petersburg City", "Saint Petersburg",
                                    $12 "  >>  ");
                  else if ($12 ~ "Tele2 Russia .* \\(ROS\\)$")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                    "Rostov", "Rostov-na-donu", $12 "  >>  ");
                  else if ($12 ~ "Tele2 Russia .* \\(NIN\\)$")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                    "Nizhegorod", "Nizhniy Novgorod",
                                    $12 "  >>  ");
                  break
              case "Kyyiv":                         # Ukraine
                  if ($10 == "")
                      $10 = "Kiev";     # or "Kyyiv" -> "Kyyivs'ka Oblast'"?
                  break
              case "":                              # Singapore
                  if ($8 == "Singapore")
                      $10 = "Singapore";
                  break
              case "Slough":                        # United Kingdom
                  if ($10 == "London")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "London", "London");
                  break
          }
          switch ($10) {
              case "Tolyatti":                      # Russian Federation
              case "Tol'yatti":
              case "Togliatti-on-the-volga":
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
              case "Gelendjik":
                  $10 = "Gelendzhik";
                  break
              case "Nal'chik":
                  $10 = "Nalchik";
                  break
              case "Engel's":
                  $10 = "Engels";
                  break
              case "Ekaterinburg":
                  $10 = "Yekaterinburg";
                  break
              case "Novoural'sk":
                  $10 = "Novouralsk";
                  break
              case "Sverdlovsk":
                  if ($9 == "Sverdlovsk")
                      $10 = "Yekaterinburg";
                  break
              case "Kamensk-ural'skiy":
                  $10 = "Kamensk-uralskiy";
                  break
              case "Kamensk":
                  if ($9 == "Sverdlovsk")
                      $10 = "Kamensk-uralskiy";
                  break
              case "Al'met'yevsk":
                  $10 = "Almetyevsk";
                  break
              case "Nizhni Tagil":
              case "Nizhny Tagil":
                  $10 = "Nizhniy Tagil";
                  break
              case "Tagil":
                  if ($9 == "Tatarstan") {
                      $9 = "Sverdlovsk";
                      $10 = "Nizhniy Tagil"
                  }
                  break
              case "Nizhni Novgorod":
              case "Nizhnii Novgorod":
                  $10 = "Nizhniy Novgorod";
                  break
              case "Blagoveschensk":
                  $10 = "Blagoveshchensk";
                  break
              case "Stavropol'":
                  $10 = "Stavropol";
                  break
              case "Velikiy Novgorod":
                  if ($9 == "Novosibirsk")
                      $9 = "Novgorod";
                  break
              case "Orel":
                  $10 = "Orël";
                  break
              case "Orenburg":
                  if ($9 == "Khabarovsk")
                      $9 = "Orenburg";
                  break
              case "Troizk":
                  if ($9 == "Chelyabinsk")
                      $10 = "Troitsk";
                  break
              case "Ozersk":
                  if ($9 == "Chelyabinsk")
                      $10 = "Ozërsk";
                  break
              case "Komsomolsk":
              case "Komsomolsk-on-amur":
                  if ($9 == "Khabarovsk")
                      $10 = "Komsomolsk-na-amure";
                  break
              case "Artem":
                  if ($9 == "Primor'ye")
                      $10 = "Artëm";
                  break
              case "Ramenskoe":
                  $10 = "Ramenskoye";
                  break
              case "Mytishi":
                  $10 = "Mytishchi";
                  break
              case "Lubertsi":
                  $10 = "Lyubertsy";
                  break
              case "Korolyov":
              case "Korolev":
                  $10 = "Korolëv";
                  break
              case "Zheleznodorozhnyy":
                  $10 = "Zheleznodorozhny";
                  break
              case "Elektrostal'":
                  $10 = "Elektrostal";
                  break
              case "Pavlovo-posad":
                  $10 = "Pavlovskiy Posad";
                  break
              case "Sergiyev Posad":
                  $10 = "Sergiev Posad";
                  break
              case "Orekhovo-zuyevo":
                  $10 = "Orekhovo-zuevo";
                  break
              case "Usolye":
                  if ($9 == "Irkutsk")
                      $10 = "Usol'ye-sibirskoye";
                  break
              case "Posad":
                  if ($9 == "Novgorod")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Moskva", "Sergiev Posad");
                  break
              case "Moskva":
                  if ($8 == "Russian Federation")
                      $10 = "Moscow";
                  break
              case "Moscow":
                  if ($9 == "Moskva")
                      $9 = "Moscow City";
                  if ($12 ~ "E-mordovia")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Mordovia", "Saransk", $12 "  >>  ");
                  break
              case "Khimki":
                  if ($9 == "Moscow City")
                      $9 = "Moskva";
                  break
              case "Zhukovskiy":
                  if ($9 == "Moscow City")
                      $9 = "Moskva";
                  break
              case "Shchelkovo":
                  if ($9 == "Moskva")
                      $10 = "Shchëlkovo";
                  break
              case "Beloozerskiy":
                  if ($9 == "Moskva")
                      $10 = "Beloozërskiy";
                  break
              case "Saint-petersburg":
              case "Sankt-peterburg":
              case "St Petersburg":
              case "Leningrad":
                  $10 = "Saint Petersburg";
                  break
              case "Petergof":
              case "Petrodvorets":
                  if ($9 == "Saint Petersburg City")
                      $10 = "Peterhof";
                  break
              case "Belebei":
                  $10 = "Belebey";
                  break
              case "Staryy Oskol":
                  $10 = "Stary Oskol";
                  break
              case "Alexandrov":
                  $10 = "Aleksandrov";
                  break
              case "Pervoural'sk":
                  $10 = "Pervouralsk";
                  break
              case "Pereslavl'-zalesskiy":
                  $10 = "Pereslavl-zalesskiy";
                  break
              case "Prokop'yevsk":
                  $10 = "Prokopyevsk";
                  break
              case "Serpuhov":
                  $10 = "Serpukhov";
                  break
              case "Mineralnye":
              case "Mineralnye Vody":
                  if ($9 == "Stavropol'")
                      $10 = "Mineralnyye Vody";
                  break
              case "Naberezhnyye Chelny":
                  if ($9 == "Tatarstan")
                      $10 = "Chelny";
                  break
              case "Elabuga":
                  if ($9 == "Tatarstan")
                      $10 = "Yelabuga";
                  break
              case "Innopolis":
                  if ($9 == "" && $8 == "Russian Federation")
                      $9 = "Tatarstan";
                  break
              case "Tatarstan":
                  if ($9 == "Tatarstan")
                      $10 = "";
                  break
              case "Tjumen":
                  if ($9 == "Tyumen'")
                      $10 = "Tyumen";
                  break
              case "Kuban":
                  if ($9 == "Krasnodar")
                      $10 = "";
                  break
              case "Yeisk":
                  if ($9 == "Krasnodar")
                      $10 = "Yeysk";
                  break
              case "Ryazan'":
                  if ($9 == "Ryazan'")
                      $10 = "Ryazan";
                  else if ($9 == "Moskva")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Nizhegorod", "Nizhniy Novgorod");
                  break
              case "Tayshet":
                  if ($9 == "Irkutsk")
                      $10 = "Taishet";
                  break
              case "Moskovskaya":
                  if ($9 == "Kirov")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Sverdlovsk", "Yekaterinburg");
                  break
              case "Moskovskiy":
                  if ($9 == "Moskva" &&
                      $12 == "Rosevrobank" ||
                      $12 == "YANDEX LLC" ||
                      $12 ~ "Moskovskiy Gosudarstvennyy")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Moscow City", "Moscow");
                  else if ($12 == "JSC ER-Telecom Holding Ryazan' Branch")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Ryazan'", "Ryazan");
                  break
              case "Ural":
                  if ($9 == "Krasnoyarsk")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Sverdlovsk", "Yekaterinburg");
                  break
              case "Yaroslavl":
                  if ($9 == "Kirov")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Yaroslavl'", $10);
                  break
              case "Belgorod":
                  if ($9 == "Bryansk")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Belgorod", $10);
                  break
              case "Stavropol":
                  if ($9 == "Samara")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Stavropol'", $10);
                  break
              case "Samara":
                  if ($9 == "Orel")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Samara", $10);
                  break
              case "Saint Petersburg":
                  if ($9 == "Moscow City" && $12 == "Google Proxy")
                      suspicious_repl2(substr($1, 2), $2, 8, 9, 10,
                                       "United States", "California",
                                       "Mountain View", $12 "  >>  ");
                  break
              case "Kirov":
                  if ($9 == "Stavropol'")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Kirov", $10);
                  break
              case "Kazan":
                  if ($9 == "Kirov")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Tatarstan", $10);
                  break
              case "Ufa":
                  if ($9 == "Chelyabinsk")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Bashkortostan", $10);
                  break
              case "Izhevsk":
                  if ($12 == "Saint-Petersburg State University of Information")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Saint Petersburg City",
                                      "Saint Petersburg", $12 "  >>  ");
                  break
              case "Krasnoarmeyskaya":
                  if ($12 ~ "Petersburg State University of Architecture")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Saint Petersburg City",
                                      "Saint Petersburg", $12 "  >>  ");
                  break
              case "Arkhangel'sk":
                  $10 = "Arkhangelsk";
                  break
              case "Arkhangelsk":
                  if ($9 == "Chelyabinsk")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Arkhangel'sk", $10);
                  break
              case "Birzha":
                  if ($9 == "Arkhangel'sk")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Arkhangel'sk", "");
                  break
              case "Krasnogorsk":
                  if ($9 == "Smolensk")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Moskva", $10);
                  break
              case "Bras":
                  if ($9 == "Sakhalin")
                      if ($12 == "Assignment for second BRAS")
                          suspicious_repl(substr($1, 2), $2, 9, 10,
                                          "Udmurt", "Izhevsk");
                      else # if ($12 == "for BRAS ats")
                          suspicious_repl(substr($1, 2), $2, 9, 10,
                                          $9, "");
                  break
              case "Start":
                  if ($9 == "Khabarovsk")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      $9, "");
                  break
              case "Petropavlovsk-kamchatsky":
                  $9 = "Kamchatka"
                  $10 = "Petropavlovsk-kamchatskiy";
                  break
              case "Petropavlovsk":
                  if ($9 == "Volgograd" || $12 ~ "InterkamService")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Kamchatka", "Petropavlovsk-kamchatskiy");
                  break
              case "Zarechenskiy":
                  if ($9 == "Volgograd")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      $9, "Volzhskiy");
                  break
              case "Zarechnyy":
                  $10 = "Zarechny";
                  break
              case "Zarechny":
                  if ($9 == "Lipetsk" && $12 ~ "Penzenskie Telecom")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Penza", $10);
                  break
              case "Mega":
                  if ($9 == "Leningrad")
                      if ($12 ~ "Mega-N")
                          suspicious_repl(substr($1, 2), $2, 9, 10,
                                          "Nizhegorod", "Nizhniy Novgorod");
                      else if ($12 ~ "Mega-Telecom")
                          suspicious_repl(substr($1, 2), $2, 9, 10,
                                          "Ryazan'", "Ryazan");
                  break
              case "Vega":
                  if ($9 == "Tatarstan")
                      if ($12 ~ "Vega[- ]Service")
                          suspicious_repl(substr($1, 2), $2, 9, 10,
                                          "Chelyabinsk", "Snezhinsk");
                  break
              case "Kostroma":
                  if ($9 == "Chelyabinsk")
                      if ($12 ~ "Kostroma Municipal")
                          suspicious_repl(substr($1, 2), $2, 9, 10,
                                          "Kostroma", $10);
                      else
                          suspicious_repl(substr($1, 2), $2, 9, 10,
                                          "", "");
                  break
              case "Sakhalin":
                  if ($9 == "Ul'yanovsk")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Sakhalin", "Yuzhno-sakhalinsk");
                  break
              case "Yugra":
                  if ($9 == "Vologda" && $12 ~ "Yugra State University")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Khanty-Mansiy", "Khanty-mansiysk");
                  break
              case "Gogolya":
                  if ($12 == "Kurgan state university")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Kurgan", "Kurgan");
                  break
              case "Sibir":
                  if ($9 == "Kirov" && $12 ~ "RTComm-Sibir")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      $9, "");
                  break
              case "Novaya":
                  if ($9 == "Khanty-Mansiy" && $12 ~ "Novaya Sibir Plus")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Irkutsk", "Bratsk");
                  # Ukraine
                  if ($9 == "Donets'ka Oblast'")
                      # or probably "Nova Kakhovka" as IP2Location shows
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Khersons'ka Oblast'", "Kherson");
                  break
              case "Bulgakov":
                  if ($9 == "Volgograd" && $12 ~ "Bulgakov Aleksey")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Moscow City", "Moscow");
                  break
              case "Zvezda":
                  if ($9 == "Saratov" && $12 ~ "Zvezda Telecom")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Moscow City", "Moscow");
                  break
              case "Nauka":
                  if ($9 == "Saratov" && $12 ~ "Nauka-Svyaz")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Moscow City", "Moscow");
                  break
              case "Keldysh":
                  if ($9 == "Udmurt" && $12 ~ "Moscow Aviation Institute")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Moscow City", "Moscow");
                  break
              case "Iskra":
                  if ($9 == "Saratov" && $12 == "ISKRA R&D Corporation")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Krasnoyarsk", "Krasnoyarsk");
                  break
              case "Novy":
                  if ($9 == "Krasnodar" && $12 ~ "OAO Novy Impulse")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      $9, "");
                  break
              case "Kopeysk":
                  if ($9 == "Krasnodar")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Chelyabinsk", $10);
                  break
              case "Sukhanova":
                  if ($9 == "Smolensk" && $12 == "Far Eastern State University")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Primor'ye", "Vladivostok");
                  break
              case "Gzhel":
                  if ($12 ~ "Telecom MPK$")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Moskva", "Dubna", $12 "  >>  ");
                  else if ($12 == "Yandex enterprise network")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Moscow City", "Moscow", $12 "  >>  ");
                  break
              case "Krasnoznamensk":
                  if ($9 == "Mordovia")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Moskva", $10);
                  break
              case "Rosha":
                  if ($9 == "Kaluga")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Krasnodar", "Krasnodar");
                  break
              case "Kuznetskiy Rayon":
                  if ($9 == "Kemerovo")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      $9, "Novokuznetsk");
                  break
              case "Volga":
                  if ($9 == "Yaroslavl'") {
                      if ($12 == "Nizhegorodskaya Cellular Communications")
                          suspicious_repl(substr($1, 2), $2, 9, 10,
                                          "Nizhegorod", "Nizhniy Novgorod");
                      else if ($12 == "samtel")
                          suspicious_repl(substr($1, 2), $2, 9, 10,
                                          "Samara", "Samara");
                  }
                  break
              case "Cesky Tesin":
                  if ($2 == "5.59.57.175")
                      suspicious_repl2(substr($1, 2), $2, 8, 9, 10,
                                       "Russian Federation", "Rostov", "Azov",
                                       $12 "  >>  ");
                  break
              case "Temryuk":
                  if ($9 == "Moscow City" && $12 == "Intertelecom Ltd(PDSN)")
                      suspicious_repl2(substr($1, 2), $2, 8, 9, 10,
                                       "Ukraine", "", "", $12 "  >>  ");
                  break
              case "":
                  if ($9 == "Leningrad")
                      $9 = "Saint Petersburg City";
                  else if ($9 == "Moskva")
                      $9 = "Moscow City";
                  else if ($9 == "Sakha" && $12 == "CJSC AIST")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Samara", "Samara");
                  else if ($9 == "Novosibirsk" && $12 ~ "N\\. Novgorod")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Nizhegorod", "Nizhniy Novgorod");
                  else if ($9 == "Smolensk" &&
                           $12 ~ "Institution of the Khanty-Mansi")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Khanty-Mansiy", "Khanty-mansiysk");
                  else if ($9 == "Khanty-Mansiy" && $12 ~ "Ekaterinburg-2000")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Sverdlovsk", "Yekaterinburg",
                                      $12 "  >>  ");
                  else if ($9 == "Tula" && $12 == "Electronniy gorod, Ltd.")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Irkutsk", "Irkutsk", $12 "  >>  ");
                  else if ($9 == "Chelyabinsk") {
                      if ($12 == "Severo-Zapad Ltd")
                          suspicious_repl(substr($1, 2), $2, 9, 10,
                                    "Leningrad", "Gatchina", $12 "  >>  ");
                      else if ($12 == "OOOEkspert-sistema")
                          suspicious_repl(substr($1, 2), $2, 9, 10,
                                    "Saint Petersburg City", "Saint Petersburg",
                                    $12 "  >>  ");
                  }
                  else if ($9 == "Orel")    # up to July 2016
                                            # they all appeared to be Samara
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Samara", "Samara");
                  else if ($9 == "Ul'yanovsk" && $12 ~ "Sakhalin Telecom")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Sakhalin", "Yuzhno-sakhalinsk");
                  else if ($8 == "Czech Republic" && $12 == "CENTEL s.r.o." &&
                           $15 ~ "\\.ru/")
                      suspicious_repl2(substr($1, 2), $2, 8, 9, 10,
                                       "Russian Federation", "Rostov", "Aksay",
                                       $12 "  >>  ");
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
              case "Dnipro":
                  $10 = "Dnepropetrovsk";
                  break
              case "Kamyanske":
                  if ($9 == "Dnipropetrovs'ka Oblast'")
                      $10 = "Dneprodzerzhinsk";
                  break
              case "Mykolaiv":
                  $10 = "Mykolayiv";
                  break
              case "Mykolayiv":
                  if ($9 == "Mykolayivs'ka Oblast'")
                      $10 = "Nikolaev";
                  break
              case "Luhansk":
                  $10 = "Lugansk";
                  break
              case "Lugansk":
                  if ($9 == "Zaporiz'ka Oblast'")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Luhans'ka Oblast'", $10);
                  break
              case "Irpin":
                  if ($9 == "Kyyivs'ka Oblast'")
                      $10 = "Irpen";
                  break
              case "Vasylkiv":
                  if ($9 == "Kyyivs'ka Oblast'")
                      $10 = "Vasilkov";
                  break
              case "Vinnytsya":
              case "Vinnytsia":
                  $10 = "Vinnitsa";
                  break
              case "Pirogov":
                  if ($12 == "Vinnica State Medical University of M.I.Pirogov")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Vinnyts'ka Oblast'", "Vinnitsa");
                  break
              case "Sokolivka":
                  if ($12 == "Inmart-Internet LTD")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Donets'ka Oblast'", "Horlivka",
                                      $12 "  >>  ");
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
              case "Ivano-frankivsk":
                  $10 = "Ivanofrankovsk";
                  break
              case "Chortkiv":
                  $10 = "Chortkov";
                  break
              case "Kyiv":
                  $10 = "Kiev";
                  break
              case "Kropyvnytskyy":
                  $10 = "Kirovograd";
                  break
              case "Zaporozhye":
              case "Zaporozhe":
                  $10 = "Zaporizhzhya";
                  break
              case "Kryvyy Rih":
                  $10 = "Krivoy Rog";
                  break
              case "Khmelnytskyy":
                  $10 = "Khmelnitskiy";
                  break
              case "Pervomaysk":
                  if ($9 == "Mykolayivs'ka Oblast'")
                      $10 = "Pervomaisk";
                  break
              case "Kramators'k":
                  $10 = "Kramatorsk";
                  break
              case "Makeevka":
                  $10 = "Makiyivka";
                  break
              case "Sloviansk":
                  $10 = "Slavyansk";
                  break
              case "Krasnyi Luch":
                  $10 = "Krasnyj Luch";
                  break
              case "Novohrodivka":
                  $10 = "Novogrodovka";
                  break
              case "Lysychansk":
                  if ($9 == "Luhans'ka Oblast'")
                      $10 = "Lisichansk";
                  break
              case "Henichesk":
                  if ($9 == "Khersons'ka Oblast'")
                      $10 = "Genichesk";
                  break
              case "Drohobych":
                  if ($9 == "L'vivs'ka Oblast'")
                      $10 = "Drogobych";
                  break
              case "Kiev":
                  if ($9 == "L'vivs'ka Oblast'")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Kyyiv", $10);
                  break
              case "Krivoy Rog":
                  if ($9 == "Khersons'ka Oblast'")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Dnipropetrovs'ka Oblast'", $10);
                  break
              case "Mirgorod":
                  if ($9 == "Kharkivs'ka Oblast'")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Poltavs'ka Oblast'", $10);
                  break
              case "Sevastopol":
                  if ($9 == "Kaluga")
                      suspicious_repl2(substr($1, 2), $2, 8, 9, 10,
                                       "Ukraine", "Sevastopol'", $10,
                                       $12 "  >>  ");
                  break
              case "Saki":
                  if ($9 == "Smolensk")
                      suspicious_repl2(substr($1, 2), $2, 8, 9, 10,
                                       "Ukraine", "Krym", $10,
                                       $12 "  >>  ");
                  break
              case "Dmitriy":
                  if ($12 == "Bystrov Dmitriy Sergeevich")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Luhans'ka Oblast'", "Lugansk");
                  break
              case "Oleg":
                  if ($12 == "Oleg Vereshchinsky PE")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "", "");
                  break
              case "Kurilov":
                  if ($12 == "SPD Kurilov Sergiy Oleksandrovich")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Poltavs'ka Oblast'", "Kremenchug");
                  break
              case "Zastava":
                  if ($12 == "PP Zastava Plus")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Odes'ka Oblast'", "Odessa");
                  break
              case "Pokrovsk":
                  if ($2 == "31.148.171.214")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Donets'ka Oblast'", "Rodinskoye",
                                      $2 "  >>  ");
                  break
              case "Mogilev":                       # Belarus
                  $10 = "Mogilëv";
                  break
              case "Polatsk":
                  $10 = "Polotsk";
                  break
              case "Navapolatsk":
                  $10 = "Novopolotsk";
                  break
              case "Horad Minsk":
                  $10 = "Minsk";
                  break
              case "Horad Zhodzina":
                  $10 = "Zhodino";
                  break
              case "Hrodna":
                  $10 = "Grodno";
                  break
              case "Babruysk":
                  $10 = "Bobruisk";
                  break
              case "Dzyarzhynsk":
                  $10 = "Dzerjinsk";
                  break
              case "Maladziecna":
                  $10 = "Molodechno";
                  break
              case "Grodno":
                  if ($9 == "Minskaya Voblasts'")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Hrodzyenskaya Voblasts'", $10);
                  break
              case "Gomel":
                  if ($9 == "Vitsyebskaya Voblasts'")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Homyel'skaya Voblasts'", $10);
                  break
              case "Baranovichi":
                  if ($9 == "Vitsyebskaya Voblasts'")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Brestskaya Voblasts'", $10);
                  break
              case "Mazyr":
                  if ($9 == "Homyel'skaya Voblasts'")
                      $10 = "Mozyr";
                  break
              case "Rechytsa":
                  if ($9 == "Homyel'skaya Voblasts'")
                      $10 = "Rechitsa";
                  break
              case "Erevan":                        # Armenia
                  $10 = "Yerevan";
                  break
              case "Qostanay":                      # Kazakhstan
                  $10 = "Kostanay";
                  break
              case "Aktobe":
                  if ($9 == "Almaty")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Almaty City", "Almaty");
                  break
              case "Gorod Bishkek":                 # Kyrgyzstan
                  $10 = "Bishkek";
                  break
              case "Bischkek":
                  if ($8 == "Kyrgyzstan") {
                      $9 = "Bishkek";
                      $10 = "Bishkek";
                  }
                  break
              case "Frankfurt":                     # Germany
                  if ($9 == "Hessen")
                      $10 = "Frankfurt Am Main";
                  else if ($9 == "Nordrhein-Westfalen")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Hessen", "Frankfurt Am Main");
                  break
              case "Muenster":
                  $10 = "Münster";
                  break
              case "Munchen":
                  if ($9 == "Bayern")
                      $10 = "Munich";
                  break
              case "Nuremberg":
              case "Nurnberg":
                  if ($9 == "Bayern")
                      $10 = "Nürnberg";
                  break
              case "Tubingen":
                  if ($9 == "Baden-Wurttemberg")
                      $10 = "Tübingen";
                  break
              case "Hufingen":
                  if ($9 == "Baden-Wurttemberg")
                      $10 = "Hüfingen";
                  break
              case "Dusseldorf":
                  if ($9 == "Nordrhein-Westfalen")
                      $10 = "Düsseldorf";
                  break
              case "Koln":
                  if ($9 == "Nordrhein-Westfalen")
                      $10 = "Köln";
                  break
              case "Krakow":                        # Poland
                  if ($9 == "Malopolskie")
                      $10 = "Kraków";
                  break
              case "Polska":
                  if ($9 == "Kujawsko-Pomorskie" && $12 ~ "Polska")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      $9, "", $12 "  >>  ");
                  break
              case "Geneve":                        # Switzerland
                  if ($9 == "Geneve")
                      $10 = "Geneva";
                  break
              case "Antwerp":                       # Belgium
                  if ($8 == "Belgium")
                      $10 = "Antwerpen";
                  break
              case "Lyngby":                        # Denmark
                  if ($9 == "Midtjyllen")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Hovedstaden", "Kongens Lyngby");
                  break
              case "Aarhus C":
                  $10 = "Aarhus";
                  break
              case "A Coruña":                      # Spain
                  if ($9 == "Galicia")
                      $10 = "La Coruña";
                  break
              case "Compostela":
                  if ($12 == "Universidad de Santiago de Compostela")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Galicia", "Santiago De Compostela",
                                      $12 "  >>  ");
                  break
              case "Arnold":                        # United Kingdom
                  if ($9 == "Nottinghamshire" && $12 == "Andrews & Arnold Ltd")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Berkshire", "Bracknell", $12 "  >>  ");
                  break
              case "Southend":
                  if ($12 == "Scaleway" && $15 ~ "\\.fr/")
                      suspicious_repl2(substr($1, 2), $2, 8, 9, 10,
                                       "France", "", "", $12 "  >>  ");
                  break
              case "Ceska":                         # Czech Republic
                  if ($9 == "Jihomoravsky kraj" && $12 ~ "UPC Ceska republika")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "", "", $12 "  >>  ");
                  break
              case "São Paulo":                     # Brazil
                  $10 = "Sao Paulo";
                  break
              case "São Carlos":
                  $10 = "Sao Carlos";
                  break
              case "Brasília":
                  $10 = "Brasilia";
                  break
              case "Goiânia":
                  $10 = "Goiania";
                  break
              case "Ciudad De Mexico":              # Mexico
                  $10 = "Mexico";
                  break
              case "León":
                  $10 = "Leon";
                  break
              case "Queretaro":
                  $10 = "Querétaro";
                  break
              case "Limasol":                       # Cyprus
                  $10 = "Limassol";
                  break
              case "Bengaluru":                     # India
                  if ($9 == "Karnataka")
                      $10 = "Bangalore";
                  break
              case "Ho Chi Minh City":              # Vietnam
                  if ($9 != "Ho Chi Minh")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Ho Chi Minh", $10);
                  break
              case "Hanoi":
                  if ($9 == "Dac Lac" || $9 == "An Giang")
                      suspicious_repl(substr($1, 2), $2, 9, 10, "", $10);
                  break
              case "Bangkok":                       # Thailand
                  if ($9 != "Krung Thep")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Krung Thep", $10);
                  break
              case "Nanshan":                       # China
                  if ($9 == "Hunan")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Guangdong", $10);
                  break
              case "Shibuya-ku":                    # Japan
                  if ($9 == "Tokyo")
                      $10 = "Shibuya";
                  break
              case "Dushanbe":                      # Tajikistan
                  if ($8 == "Tajikistan")
                      $9 = "Dushanbe";
                  break
              case "Tbilisi":                       # Georgia
                  if ($9 == "Dushet'is Raioni")
                      $9 = "";
                  break
              case "Tallin":                        # Estonia
                  if ($8 == "Estonia")
                      $10 = "Tallinn";
                  break
              case "Jackson St Forest":             # United States
                  if ($9 == "California")
                      suspicious_repl(substr($1, 2), $2, 9, 10, $9, "");
                  break
          }
          switch ($12) {
              case "EUNnet":
                  if ($9 != "Sverdlovsk" || $10 != "Yekaterinburg")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                "Sverdlovsk", "Yekaterinburg", $12 "  >>  ");
                  break
              case "Intek-m LLC":
                  if ($9 != "Moskva" || $10 != "Mytishchi")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Moskva", "Mytishchi", $12 "  >>  ");
                  break
              case "Atlas Telecom Ltd.":
                  if ($10 != "Tambov")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                "Tambovskaya oblast", "Tambov", $12 "  >>  ");
                  break
              case "Jsc Pp Potok":
                  if ($9 != "Stavropol'" || $10 != "Pyatigorsk")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Stavropol'", "Pyatigorsk", $12 "  >>  ");
                  break
              case "Tele2 Kazakhstan":
                  if ($8 == "Sweden")
                      suspicious_repl2(substr($1, 2), $2, 8, 9, 10,
                                       "Kazakhstan", "", "", $12 "  >>  ");
                  break
              case "Lubman UMCS sp. z o.o. network":
                  if ($9 != "Lubelskie" || $10 != "Lublin")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Lubelskie", "Lublin", $12 "  >>  ");
                  break
              case "SkyExchange Internet Access":
                  if ($8 == "Canada")
                      suspicious_repl2(substr($1, 2), $2, 8, 9, 10,
                                       "Hong Kong", "", "", $12 "  >>  ");
                  break
              case "Kar-Tel LLC":
                  if ($8 == "Romania")
                      suspicious_repl2(substr($1, 2), $2, 8, 9, 10,
                                       "Kazakhstan", "", "", $12 "  >>  ");
                  break
              case "Lux-ua-kiev":
              case "Lux-ua-dnepr":
              case "Lux-usa-ny-r":
                  if ($8 == "Romania")
                      suspicious_repl2(substr($1, 2), $2, 8, 9, 10,
                                       "Ukraine", "", "", $12 "  >>  ");
                  break
              case "LLC texnoprosistem":
                  if ($8 == "Korea, Republic of")
                      suspicious_repl2(substr($1, 2), $2, 8, 9, 10,
                                       "Uzbekistan", "", "", $12 "  >>  ");
                  break
          }
          print
        }

END     { if (suspicious_count > 0)
              printf "%s (%d repls)\n", delim,
                     suspicious_count > "/dev/stderr";
          if (spam_count > 0)
              printf "%s (%d spam records deleted)\n", delim2,
                     spam_count > "/dev/stderr"
        }

# Potentially ambiguos locations (you may want to check them with whois):
#   Donetsk (Rostov) -> Donetsk (Donets'ka Oblast')

# Suspicious locations with no clue to resolve (or too old to check):
#   Niva (Ryazan') -> Nizhniy Novgorod (Nizhegorod)  [92.255.244.51]
#   Volga (Yaroslavl') -> ???, for those of them with OJSC/PJSC Megafon
#   Sulin (Rostov) -> Krasny Sulin (Rostov), Sulin is a small khutor

