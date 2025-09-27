'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "58b522cfa2565c199cc5c4fc6863361b",
"assets/AssetManifest.bin.json": "4471938eb3a5cf25e4ba947a9db22a44",
"assets/AssetManifest.json": "4a6fd1d33d3ff67da045ff8d7e9c1cce",
"assets/assets/flags/ad.svg": "e2990f5d4e513a5c2d9b0c6ab1c0ff0f",
"assets/assets/flags/ae.svg": "978a52765a1465503702ee3142b0e377",
"assets/assets/flags/af.svg": "d8fb0d22695c18d1386db82b04975f4e",
"assets/assets/flags/ag.svg": "7a5c6f517a63f92c48c28b01a57cbef0",
"assets/assets/flags/ai.svg": "96e24e9ea6a063bdccddd095adc12265",
"assets/assets/flags/al.svg": "bfd0a0ce61206943fff472f113d33b06",
"assets/assets/flags/am.svg": "6ab4c4d01258b49ae3632193bdff9a80",
"assets/assets/flags/ao.svg": "2359a082179b9fee8acd24178b026f0e",
"assets/assets/flags/aq.svg": "65a5c99b3b2aebf97e7809e2118c5386",
"assets/assets/flags/ar.svg": "51c7aeb1c396a01c26b82715f184fafc",
"assets/assets/flags/as.svg": "caaf405e70cccb4c0f966ba16afc08fc",
"assets/assets/flags/at.svg": "8ba54155e9ecb4ad97557a8f03867244",
"assets/assets/flags/au.svg": "e875a51ef2beb891fd6f4b9e117a243e",
"assets/assets/flags/aw.svg": "ab68008c5f85c16bf2d397586df566bb",
"assets/assets/flags/ax.svg": "d78ede0e69cf839ae6fb2ad94a44931d",
"assets/assets/flags/az.svg": "b02e1d897dc8b69d76b9e11a5028bce3",
"assets/assets/flags/ba.svg": "ff62357b2774c3a13827b1491d060aed",
"assets/assets/flags/bb.svg": "3fb12ea551927c657572d7b0a8132a2d",
"assets/assets/flags/bd.svg": "05e8826ead4a5d6e93ce0994a0146057",
"assets/assets/flags/be.svg": "2f762fbb9229f8516dbc76e9cb0cba36",
"assets/assets/flags/bf.svg": "c07fc50c377d9623f17fa98dbd274c2e",
"assets/assets/flags/bg.svg": "1756f2d9216f7b40e44f1af652123287",
"assets/assets/flags/bh.svg": "0dc78a04794c407895e93acc6b428292",
"assets/assets/flags/bi.svg": "cf790c09c38acf63e40c9b83665b78bb",
"assets/assets/flags/bj.svg": "2f8ccc907304f469b7dc5745ba457b44",
"assets/assets/flags/bl.svg": "55df0a2ef57eac8ddd89542eb3e94634",
"assets/assets/flags/bm.svg": "7d91827f0f3930f645a0135ffe9eeb30",
"assets/assets/flags/bn.svg": "e1882e0d1a24b1cf738cae33f46ed517",
"assets/assets/flags/bo.svg": "24408e4f5f84152023ba274bd2b38afa",
"assets/assets/flags/bq.svg": "5f6ef944bbde5608a5cfd566abc3a61a",
"assets/assets/flags/br.svg": "92fc6153bcbb7cf496739e02c35545a1",
"assets/assets/flags/bs.svg": "f74bac5155d5f6e9f023efe1c8ebd633",
"assets/assets/flags/bt.svg": "927ecffd501a46bd5bb3fe7cb8ef08e7",
"assets/assets/flags/bv.svg": "d91702a1c191c9c9acf42155cc180342",
"assets/assets/flags/bw.svg": "b3272f19a67d23420f36929a4a960a90",
"assets/assets/flags/by.svg": "0a7149c26007c63c6e3cad49d57f8a64",
"assets/assets/flags/bz.svg": "b76fcd7d431d2f625d7482be7d790e74",
"assets/assets/flags/ca.svg": "f8c2d1128e2e35a38fff9f40886bec5c",
"assets/assets/flags/cc.svg": "985a76c54696f933c217f4fb6f50a93a",
"assets/assets/flags/cd.svg": "c6cc7e0f163b91dc6083b8251454f546",
"assets/assets/flags/cf.svg": "97629cb9876aea4e0581e91c33fdb7bd",
"assets/assets/flags/cg.svg": "f2e458f5f49ae9ba87a13d90155b4bf8",
"assets/assets/flags/ch.svg": "72a8289193c9d7e01f4c040cef075e91",
"assets/assets/flags/ci.svg": "6bf90550d7e8b2f82288e9a87e8dbb14",
"assets/assets/flags/ck.svg": "420c555e0bacbc73803f64f56df0dd33",
"assets/assets/flags/cl.svg": "65517b63175b1d550c077cfc2d4003a2",
"assets/assets/flags/cm.svg": "b4c9e39c20abe11763fccf93b5eb45bd",
"assets/assets/flags/cn.svg": "c40591ea8ab99866733b24a433e6bfe1",
"assets/assets/flags/co.svg": "d1a61f9499bd5d5ab4ffa6dcb3ce5c09",
"assets/assets/flags/cr.svg": "74dd61b6fdb8b783d209a264af09c363",
"assets/assets/flags/cu.svg": "89e88662230b6d09130b18c77cbf2659",
"assets/assets/flags/cv.svg": "c823e98891ff7685b997a8bf4a13662f",
"assets/assets/flags/cw.svg": "7dbea206d4d61e620bfdea0fea27ac69",
"assets/assets/flags/cx.svg": "a434363645c22e5ce1e5b2bde8dd0282",
"assets/assets/flags/cy.svg": "ce826661e7ca1778b9bb3a768ff69d13",
"assets/assets/flags/cz.svg": "047e732decd62b9d3ce350a2cd8f4de6",
"assets/assets/flags/de.svg": "a1435756748c8f549926e144f81ba7d4",
"assets/assets/flags/dj.svg": "02e75e20b28d717bca170367021afd72",
"assets/assets/flags/dk.svg": "c0cd63470ccdd66eb1b70437c4897d2e",
"assets/assets/flags/dm.svg": "3a68c10ddff99e1ac8801caeedeb9527",
"assets/assets/flags/do.svg": "4ba64fb6d96b7b61fc485af337d348fd",
"assets/assets/flags/dz.svg": "0ffabba444bc348f5bb9adf03ffe37c8",
"assets/assets/flags/ec.svg": "b526c480b1ec84810c0c3e8f74ba9c6b",
"assets/assets/flags/ee.svg": "dd2a64a6d751df1bf99b6f94965ca9f6",
"assets/assets/flags/eg.svg": "d89ba3620f7a1abc972f941c319f2aa1",
"assets/assets/flags/eh.svg": "4d3df2560dceed63f1372ccad6706e2e",
"assets/assets/flags/er.svg": "804cbebd72e805855091721b15486dba",
"assets/assets/flags/es.svg": "c3853709f676abcc9c50ce691004cdb5",
"assets/assets/flags/et.svg": "15040bfc4d5133a3815d76b860560244",
"assets/assets/flags/eu.svg": "93555e17d1d15b323bd82096f351860c",
"assets/assets/flags/fi.svg": "079f4bcbd1f4a3a2ac55d1071961eaa4",
"assets/assets/flags/fj.svg": "41e534b0b6aa4966460cf1d660e6f7ca",
"assets/assets/flags/fk.svg": "4e9526a86d502e1780e4b62329d7931a",
"assets/assets/flags/fm.svg": "2d1657d1b90eec1e16d1d5ebf4a49c08",
"assets/assets/flags/fo.svg": "8f0093440014f1c0721a4108ffdf1a4f",
"assets/assets/flags/fr.svg": "55df0a2ef57eac8ddd89542eb3e94634",
"assets/assets/flags/ga.svg": "e554f938225964e2f0e68468023dd5eb",
"assets/assets/flags/gb-eng.svg": "2d5bac56a4ce420c040d5fa963855cdb",
"assets/assets/flags/gb-nir.svg": "c39480d514fe1af4c7e5f62a3ac53b67",
"assets/assets/flags/gb-sct.svg": "dd6733a9e9745ddf1d91171c89fcbcaa",
"assets/assets/flags/gb-wls.svg": "9f7c50cf094d59a85e35b3ee0a211341",
"assets/assets/flags/gb.svg": "c39480d514fe1af4c7e5f62a3ac53b67",
"assets/assets/flags/gd.svg": "471a003b52c4c4cef97dbd47b0e3ce23",
"assets/assets/flags/ge.svg": "a48e99199133765bebfa6eb3fb57c5a0",
"assets/assets/flags/gf.svg": "55df0a2ef57eac8ddd89542eb3e94634",
"assets/assets/flags/gg.svg": "218797b33aacbc8cfe0ea3ee919fcbb8",
"assets/assets/flags/gh.svg": "6ad2b9cb3cf955d04794ee0cbc0a0402",
"assets/assets/flags/gi.svg": "4217c0d806ff637b14eb221fadbb31bb",
"assets/assets/flags/gl.svg": "73ae82a7002c8f6c7319b90b47e059d9",
"assets/assets/flags/gm.svg": "5bbf7b744147a5a95e5d65ae10ac2269",
"assets/assets/flags/gn.svg": "7de807363eb98f680e0e3ed25d48543f",
"assets/assets/flags/gp.svg": "55df0a2ef57eac8ddd89542eb3e94634",
"assets/assets/flags/gq.svg": "1f78740d5e97927861dfff87f50a3970",
"assets/assets/flags/gr.svg": "abd7d677957e863655f6bc059dbaebfb",
"assets/assets/flags/gs.svg": "7b9175161dcf7ea2bd55c0612f0b8d1a",
"assets/assets/flags/gt.svg": "bc5b62b6825c78f6a907cb2d6e3ace1a",
"assets/assets/flags/gu.svg": "c3db56a6be8a231a703070535cb94874",
"assets/assets/flags/gw.svg": "50cec7fde0d6e7416dd8e3602c0b1624",
"assets/assets/flags/gy.svg": "41725ef911e93869236cfdb1a89ec32c",
"assets/assets/flags/hk.svg": "b953ca2cac2476d4ac8ef3a187c18250",
"assets/assets/flags/hm.svg": "e875a51ef2beb891fd6f4b9e117a243e",
"assets/assets/flags/hn.svg": "515bf7aaaa67e85ea811c35d51cb279c",
"assets/assets/flags/hr.svg": "f4e06f4da88eab5e630a6263b8f5ebdf",
"assets/assets/flags/ht.svg": "b8bdde5ad9699575b321fd84a2c8bb0b",
"assets/assets/flags/hu.svg": "456f4b1bf9c06ec1b6f208390f5c7d0f",
"assets/assets/flags/id.svg": "a8161cf28b1411d25bbf6f037ba31cbc",
"assets/assets/flags/ie.svg": "8f8ca447d7bd556bac9dfc62a0e0063f",
"assets/assets/flags/il.svg": "033c38c0d792b6f0031e44693de50798",
"assets/assets/flags/im.svg": "46d995fdade37cc633a1a1d63794a248",
"assets/assets/flags/in.svg": "69b796abeb10976bd43a96c6185ff9bd",
"assets/assets/flags/io.svg": "84de1d2ddad45dee4b597deafc4d30b9",
"assets/assets/flags/iq.svg": "66216bd0ac029a43ca2425be1d060635",
"assets/assets/flags/ir.svg": "2cd8912993c0f84da988f86b2ca06938",
"assets/assets/flags/is.svg": "75a62d93e664c3aaca3585f359afccd6",
"assets/assets/flags/it.svg": "27fe7edcc368e9673c2869fa368c42fa",
"assets/assets/flags/je.svg": "1478f6eccf6e9968f1db8d4fdbbd8ea2",
"assets/assets/flags/jm.svg": "4daaf7077cd15b459c6d4297459b072b",
"assets/assets/flags/jo.svg": "17530dec71e4c015cfae93d2e8622b36",
"assets/assets/flags/jp.svg": "e2d838a26303d452abf1a36a833858ab",
"assets/assets/flags/ke.svg": "5d45eaae039ee035b9efcd8d39a51c16",
"assets/assets/flags/kg.svg": "b835c7fca06c7a515b807367afccdf96",
"assets/assets/flags/kh.svg": "b3dadd9fb54156c59835b3b65694d075",
"assets/assets/flags/ki.svg": "1e425fd5f0963cc828dbc2f7501ee394",
"assets/assets/flags/km.svg": "5946bdc72289eef3c983f82a18df1038",
"assets/assets/flags/kn.svg": "ad086c55274cc0390a08fad5ae414590",
"assets/assets/flags/kp.svg": "770cb198413d6cbb87d3067604cdf7a9",
"assets/assets/flags/kr.svg": "94941e047e194c9e95bdc44e8256ad0f",
"assets/assets/flags/kw.svg": "841518c8d49f53db0c814c8dd1c8cdef",
"assets/assets/flags/ky.svg": "69021ebc0998a1a685b5777607c8e85a",
"assets/assets/flags/kz.svg": "aebe1ef9087c99b2fbb7fbb2b44bc792",
"assets/assets/flags/la.svg": "ac7e695a9bd601bc2425fbf99cf65662",
"assets/assets/flags/lb.svg": "bc789b21fd21dd46a518649b0f8f9712",
"assets/assets/flags/lc.svg": "3995dda774e2c2765b997f477c1d040f",
"assets/assets/flags/li.svg": "3719ea6d2824fa73d84a99bc930d4191",
"assets/assets/flags/lk.svg": "23e5cb5fa2e1185e4db8e3ee81c19d31",
"assets/assets/flags/lr.svg": "cf309785b8e51623b4d44d24153580b5",
"assets/assets/flags/ls.svg": "79261c0847aa6887c9c0224c04f7993b",
"assets/assets/flags/lt.svg": "60ce52ef375f0a7bf84149719ad6a8e2",
"assets/assets/flags/lu.svg": "97e411b31474feacc6c389de18adede6",
"assets/assets/flags/lv.svg": "12cebcfb5d166f7cd2b6a3fb48c0924d",
"assets/assets/flags/ly.svg": "e707148ffd5f1cdafa70117b685faff7",
"assets/assets/flags/ma.svg": "caaf228d6c23417c9163d92a8cb6354f",
"assets/assets/flags/mc.svg": "9ce1d0427536843f7b1092705754ad32",
"assets/assets/flags/md.svg": "6b8abcb3fc67964d782829a5f03ba71f",
"assets/assets/flags/me.svg": "ad7afd12fc4ef2187604c530b062adac",
"assets/assets/flags/mf.svg": "55df0a2ef57eac8ddd89542eb3e94634",
"assets/assets/flags/mg.svg": "3bb33f8d36665e18367ace229c3181b7",
"assets/assets/flags/mh.svg": "1ce06f01d48462d2259bf2ce9f43ddde",
"assets/assets/flags/mk.svg": "2ac054ebfb7dd07792398d20b4c04b3e",
"assets/assets/flags/ml.svg": "6a7164947b1ce10464077e281f59a3db",
"assets/assets/flags/mm.svg": "f06bd610c7db734dc62d1e001e4a6a38",
"assets/assets/flags/mn.svg": "7bd9a92b2131e01bf11a799ec5068881",
"assets/assets/flags/mo.svg": "0dc09f497aa5f082cc54dec9022dbc27",
"assets/assets/flags/mp.svg": "91055a885cd6f27b5078ee37314e64e0",
"assets/assets/flags/mq.svg": "55df0a2ef57eac8ddd89542eb3e94634",
"assets/assets/flags/mr.svg": "4ae40103f5d907ef56b2e8a89c276958",
"assets/assets/flags/ms.svg": "672d771e5fa890e48f4fe2e1ce0f6103",
"assets/assets/flags/mt.svg": "23c648aa1c11703b36e7b8c20fbc315b",
"assets/assets/flags/mu.svg": "ca7b8131c439fdf0f16b3b10b58f3d08",
"assets/assets/flags/mv.svg": "4cca1ac70792269bed0c3e92e6687675",
"assets/assets/flags/mw.svg": "43ff7ada6b139b810508eb328d0afb83",
"assets/assets/flags/mx.svg": "216d2ed600701aa4e417b8a169fb09e1",
"assets/assets/flags/my.svg": "537daaa3ec108f311bc5f0d0bfb3ba70",
"assets/assets/flags/mz.svg": "5a4a3d84c4b763ba4aa77e3861615eac",
"assets/assets/flags/na.svg": "347a6e2536bc3156650cacb2b3f3559b",
"assets/assets/flags/nc.svg": "55df0a2ef57eac8ddd89542eb3e94634",
"assets/assets/flags/ne.svg": "fe232d8aee68a798c4e7aac73106c02e",
"assets/assets/flags/nf.svg": "9c35f8b0f713f79b77a537b430129ec0",
"assets/assets/flags/ng.svg": "ffd18fe39abc5ad5e8b2fc3f06ed2ca2",
"assets/assets/flags/ni.svg": "32e4d1fec5a0735fb7c18ddcbb9c2f64",
"assets/assets/flags/nl.svg": "5f6ef944bbde5608a5cfd566abc3a61a",
"assets/assets/flags/no.svg": "d91702a1c191c9c9acf42155cc180342",
"assets/assets/flags/np.svg": "c8a8ef36fe3edf227592d80461c5bb19",
"assets/assets/flags/nr.svg": "6b72bbc1679f1c00b994b7a6e107208e",
"assets/assets/flags/nu.svg": "971e5c2fb4acc3245687b3b775ec3e0d",
"assets/assets/flags/nz.svg": "30299530bf0b71a2fb4ccc92e4c78693",
"assets/assets/flags/om.svg": "299d7167962bd23d1354943fc51fc3c1",
"assets/assets/flags/pa.svg": "931bfe6bff90c558763bd7995f73beb0",
"assets/assets/flags/pe.svg": "ef9dac1d11d5a271b19330e27f679475",
"assets/assets/flags/pf.svg": "cd51dc27882963f1e127cf7df497eec9",
"assets/assets/flags/pg.svg": "4e87aebf78cbb07642b6851b230005c3",
"assets/assets/flags/ph.svg": "62b10c250172cf3e4817c84fcaec4fe6",
"assets/assets/flags/pk.svg": "f33c2297f8fb5f62cb7ee650ab96e828",
"assets/assets/flags/pl.svg": "e2afe0f6676f52f2142f71e9b3570e81",
"assets/assets/flags/pm.svg": "55df0a2ef57eac8ddd89542eb3e94634",
"assets/assets/flags/pn.svg": "a7cc83d26c4a11c5a6207c66b040e934",
"assets/assets/flags/pr.svg": "44606b44cafbbe9f37418d4d17e74790",
"assets/assets/flags/ps.svg": "7fb44a73a57bd1ec9983452833c0e307",
"assets/assets/flags/pt.svg": "352ff4b0729d15721611c7a4e447226f",
"assets/assets/flags/pw.svg": "c5a4b0fe80c10063805a135025d5e67b",
"assets/assets/flags/py.svg": "9f48a1101c0c44dbbd9c4ffaeea4a7ea",
"assets/assets/flags/qa.svg": "b39ab9d65d692399d4d1ffe1dde78371",
"assets/assets/flags/re.svg": "55df0a2ef57eac8ddd89542eb3e94634",
"assets/assets/flags/ro.svg": "a9e8cdfefb0cb78dfe786276f500656a",
"assets/assets/flags/rs.svg": "e4159b1cb156050904f8095f1e0a0c86",
"assets/assets/flags/ru.svg": "182478bcd33a12d3ac4fd828180bca2f",
"assets/assets/flags/rw.svg": "85f6ca97a21f7c3ae7b1a81735ebbc20",
"assets/assets/flags/sa.svg": "943cf6263106fc466d3288777a0625f2",
"assets/assets/flags/sb.svg": "2c776db7a193b08517bbf33a03b08d4a",
"assets/assets/flags/sc.svg": "049e72080b461d916d501be3418be9fb",
"assets/assets/flags/sd.svg": "8f0ac64a4c068be71e6a7565738ab5a5",
"assets/assets/flags/se.svg": "1f642770ccba1a8f5948ac69923c15ba",
"assets/assets/flags/sg.svg": "6ae2dc5b5c669b14a66f66887faa548f",
"assets/assets/flags/sh.svg": "c39480d514fe1af4c7e5f62a3ac53b67",
"assets/assets/flags/si.svg": "9a72ead658202dfbe1e78e9669753b3f",
"assets/assets/flags/sj.svg": "d91702a1c191c9c9acf42155cc180342",
"assets/assets/flags/sk.svg": "d8e0e96c0c6a411a76340b07b5f9d45b",
"assets/assets/flags/sl.svg": "890bdc296001e0863c0b29a2c474076c",
"assets/assets/flags/sm.svg": "bdd98917071e4ab71906bb31b9338913",
"assets/assets/flags/sn.svg": "42cfbd39b4b9300854bf9d0efa7d791b",
"assets/assets/flags/so.svg": "f89e77ad08b30765c33820774286ba1b",
"assets/assets/flags/sr.svg": "cbccf817f2f5d5a876927eaae5c0743f",
"assets/assets/flags/ss.svg": "562eaa768cdb55f9c306c0bdc577d5b3",
"assets/assets/flags/st.svg": "b435df972c8ce9ffb1dfa3fa3e990c1a",
"assets/assets/flags/sv.svg": "87a195b6a1c81a6bea782bc21ebc6ccc",
"assets/assets/flags/sx.svg": "8db7b1db22357ec8341fae0eaabb17bd",
"assets/assets/flags/sy.svg": "02c1d5b21b5d6a88646b55c19780840e",
"assets/assets/flags/sz.svg": "59e2dbc4ca8688166475788e0848c18f",
"assets/assets/flags/tc.svg": "729aa51167bb908ae22dd99d57234dcf",
"assets/assets/flags/td.svg": "f6b0a98f986e6848acab41748832f517",
"assets/assets/flags/tf.svg": "d9c9ef13b2bb20ad5553d75c510ea9cf",
"assets/assets/flags/tg.svg": "c270b112760346ff7dbbeec0983875db",
"assets/assets/flags/th.svg": "3530959a599c6598ef658a39717cb01f",
"assets/assets/flags/tj.svg": "ab3bac64b7e4d7b6db36a3244224fb8e",
"assets/assets/flags/tk.svg": "e5fa89eaeb9b0112e65152ef63cba37c",
"assets/assets/flags/tl.svg": "f0649357205fa4c620d712872e669003",
"assets/assets/flags/tm.svg": "b5f652960a4f4cbb4c630d4daadfdeac",
"assets/assets/flags/tn.svg": "f07a886c43903dd56aa47415935d7d27",
"assets/assets/flags/to.svg": "ba2127cbbc7f2109c419b77911814c3a",
"assets/assets/flags/tr.svg": "cf31c9d60dcd92a6c987ec49f360c29e",
"assets/assets/flags/tt.svg": "9574aff3e3c49324a07d2e4f116475e1",
"assets/assets/flags/tv.svg": "d14123479f994d99613c8e1caafcbbbb",
"assets/assets/flags/tw.svg": "74b88030a775f61ded53db4f1046399c",
"assets/assets/flags/tz.svg": "ee919c0a7c7c0bf8974d7a7f0e800bf6",
"assets/assets/flags/ua.svg": "8a287858ff33b87c62f83743dc6d959f",
"assets/assets/flags/ug.svg": "ccaa7a855e0e80a43a0852a15d27e0c7",
"assets/assets/flags/um.svg": "eadfb4edb150845cd371f170956ca9ac",
"assets/assets/flags/us.svg": "eadfb4edb150845cd371f170956ca9ac",
"assets/assets/flags/uy.svg": "6068a814d3c803850fd33f9475cbea39",
"assets/assets/flags/uz.svg": "b20f1adbc14c6cdda2bff79fc7f83680",
"assets/assets/flags/va.svg": "6182350fb1f107cfee284a4b5f970ce2",
"assets/assets/flags/vc.svg": "bd0bfc7e8acf3e0d2080b75196fdd3de",
"assets/assets/flags/ve.svg": "243693de675297aad6dc3f7da41859cc",
"assets/assets/flags/vg.svg": "ccea90f16c194b08b65a2ae5d5d4eb66",
"assets/assets/flags/vi.svg": "2cca2f616f975184bd1c7c32a27d3318",
"assets/assets/flags/vn.svg": "44c0954e79163c9d2ad311429c6cb049",
"assets/assets/flags/vu.svg": "0c83fc4f70dff5bee45f7af981fba04c",
"assets/assets/flags/wf.svg": "9cbf71ee1fed2b7ad2bd182849360664",
"assets/assets/flags/ws.svg": "adcc72ee43034c0373dbe0eecc766915",
"assets/assets/flags/xk.svg": "4f3781ca449bb8e7fae1e0de1b3ef426",
"assets/assets/flags/ye.svg": "1a89616e370595683bb48c0e4a80a6eb",
"assets/assets/flags/yt.svg": "55df0a2ef57eac8ddd89542eb3e94634",
"assets/assets/flags/za.svg": "b2f370d401fe675c820947b81c67843e",
"assets/assets/flags/zm.svg": "112bea3f49b46117b9018f04fbb3c1ac",
"assets/assets/flags/zw.svg": "bc893918e548988a4f1cb17fa23350dc",
"assets/assets/fonts/Poppins-Black.ttf": "14d00dab1f6802e787183ecab5cce85e",
"assets/assets/fonts/Poppins-Bold.ttf": "08c20a487911694291bd8c5de41315ad",
"assets/assets/fonts/Poppins-ExtraLight.ttf": "6f8391bbdaeaa540388796c858dfd8ca",
"assets/assets/fonts/Poppins-Medium.ttf": "bf59c687bc6d3a70204d3944082c5cc0",
"assets/assets/fonts/Poppins-Regular.ttf": "093ee89be9ede30383f39a899c485a82",
"assets/assets/fonts/Poppins-Thin.ttf": "9ec263601ee3fcd71763941207c9ad0d",
"assets/assets/icons/activity.svg": "e55a8e2117f6e687dbaceba19a52c35b",
"assets/assets/icons/analytics.svg": "71f39a6727328935acee74c983eb3526",
"assets/assets/icons/apple.png": "64b2ceee9f0be1a566e8bdb61ecb473a",
"assets/assets/icons/assistant.svg": "f4718d9a3655ca7bcb3655d507aaf38d",
"assets/assets/icons/bell.svg": "b2f2396f8dbf08eef2c39c9b4bf676d5",
"assets/assets/icons/biometric.svg": "467d3772c12c2f08cad519514e4e00bf",
"assets/assets/icons/bot.svg": "9885b33aefb128f97fb1383712be755b",
"assets/assets/icons/camera.png": "9b9baeb22308c9b1c34f3450d4ad2cf0",
"assets/assets/icons/cardLogo.png": "6433756846f9292b192d3097c2964ae4",
"assets/assets/icons/changePassword.svg": "15980969ea71a7ecd8d4fbc7f7fa6b37",
"assets/assets/icons/clear_icon.svg": "5b596aca711940eff96e16a0dd74ef3a",
"assets/assets/icons/clock.svg": "9be389f76f152625237b644fadaae1d2",
"assets/assets/icons/close_icon.svg": "129c24e7d6b41a2609df6ea4b077810d",
"assets/assets/icons/credit.png": "e35247e596446de7d3e0f74c9a0a426b",
"assets/assets/icons/dash.svg": "67935ee3aa309887860c89a6032c695e",
"assets/assets/icons/debit.png": "4268ff17f04c5235f11d75cba22039d6",
"assets/assets/icons/edit_icon.svg": "679ff6bc55aa30c01745b931db7ea9af",
"assets/assets/icons/facebook.png": "8c89ef8ab45d47ae9a954822532889f7",
"assets/assets/icons/face_id.svg": "93eb9378d619586d9f87eaeca5293c12",
"assets/assets/icons/gallery.png": "8ea51a9f18a866af362e74e171651b89",
"assets/assets/icons/globeIcon.svg": "b4c6b9c15b41b7b3e997160c97a9638c",
"assets/assets/icons/google.png": "ca2f7db280e9c773e341589a81c15082",
"assets/assets/icons/Group.svg": "ebd3eeaf16fd40243e02cee9fb6e4f7c",
"assets/assets/icons/hint.svg": "da1c86f878e1fb60c3c0954b10b4a3bb",
"assets/assets/icons/history_icon.svg": "8f92475db6b774767d8598d89d3679dc",
"assets/assets/icons/history_icon2.svg": "d19838a6b03d255aae9165ffe44ae5ff",
"assets/assets/icons/home.png": "1527e443d40d068dc4d77354be749228",
"assets/assets/icons/home.svg": "41bb39ccd858bb21ebbb440439ccc4fe",
"assets/assets/icons/ic_launcher.png": "7e64fd448a5619956a655802967eccee",
"assets/assets/icons/logout.svg": "ba4f01343f119a5413843f5f89e25b91",
"assets/assets/icons/manage_orders.svg": "59c2c01c1d0f7c0dba6bebb4ddbd9b28",
"assets/assets/icons/manage_user.svg": "0f7245b67b2ed5106929ce8b07d6f582",
"assets/assets/icons/measurement.svg": "2688b323cdefe26fcb5a7fa7da5081c3",
"assets/assets/icons/more_vert.svg": "15d81a4c4d7b3e5add2d09711e027e7c",
"assets/assets/icons/notification.svg": "42b1d4dd9d2219c343b709eba325f9f0",
"assets/assets/icons/orders.png": "47b005664ee3f4688b48bd22c5469881",
"assets/assets/icons/orders.svg": "ebd3eeaf16fd40243e02cee9fb6e4f7c",
"assets/assets/icons/price_setting.svg": "b07abddaae1610655e7e81a41baf742a",
"assets/assets/icons/products.png": "dd4c5575e1d1fcb6c2b7867abc8ce783",
"assets/assets/icons/profile.png": "a291808bfd91aecb067bbf51c7726dc1",
"assets/assets/icons/profile.svg": "88a5898549b475d179b6d9b81014c836",
"assets/assets/icons/reminder.svg": "aafb82c769c199c74577997b24aa0be6",
"assets/assets/icons/revanue.svg": "9651339fd93eeb0a82bc1d3c4fb98e2e",
"assets/assets/icons/setting.svg": "41c5d39521f6d601692ec1e501f962b9",
"assets/assets/icons/start_bullet.svg": "d93c8f82cea1ee44372eeb70611493d9",
"assets/assets/icons/support.svg": "5c5d1e21f939827f44c7dc9dc8ae2ae8",
"assets/assets/icons/tick.svg": "32f71502818cd882ab90bcabbed5c1cc",
"assets/assets/icons/touch_id.svg": "93eb9378d619586d9f87eaeca5293c12",
"assets/assets/icons/users.svg": "bc7ab9178fa42819b40264de60dede2e",
"assets/assets/icons/Vector-1.svg": "a4552757e52c1f217bb3ae4e38472dd4",
"assets/assets/icons/visa.png": "2bf5149d2b743c2c029dce36397d7e03",
"assets/assets/icons/wallet.png": "2f96c96f12aea9634e19b7b50acbe819",
"assets/assets/icons/wishList.png": "fb301be5d9ddfb5e237f6399af6d9117",
"assets/assets/images/app_bg.png": "880253568d3042c9a710d369f1a67683",
"assets/assets/images/board1.png": "eb2501b7f74783450743daed69850bdc",
"assets/assets/images/board2.png": "28b734ef3fbffecce61ca1086e6a55a0",
"assets/assets/images/board3.png": "a87642cb503c244a71d0b5ec9486c055",
"assets/assets/images/demoresult.png": "8da9fd905a3be6da14cb19c747ee2147",
"assets/assets/images/demoresult2.png": "5c243bbfb2c91e143d3b10b3c5270ebd",
"assets/assets/images/favicon.png": "a52a77ef4ed84e4b38048b0ae9a06ff2",
"assets/assets/images/header_bg.png": "28b3144d3e956af035998b609f25f75d",
"assets/assets/images/intro.png": "a56ec3acfb6090e0b5415bd63e981f56",
"assets/assets/images/logo.png": "cadcd24968859c46ea31cd428dbd0185",
"assets/assets/images/msg_bg.png": "b7f1959925a6bd7c2ea39cf5c939999b",
"assets/assets/images/purple_shade.png": "341bad1c8bc0e7829f392268d71e98e5",
"assets/assets/images/round.png": "4ab73b09b23eddd720590abd13276c52",
"assets/assets/images/sample1.png": "14a44415345726e8158778d5c9741f2c",
"assets/assets/images/sample2.png": "40fafc11ab8e79abcab270e1196e5f47",
"assets/assets/images/setting.png": "1f9d8b5df461f8fe331b19a8058f2234",
"assets/assets/images/shade.png": "e2590170923baa08cb981d162f86700f",
"assets/assets/images/skin.png": "ad0eba22459a0a6b4ce8a4aa10bdf199",
"assets/assets/images/skinprimary.png": "3c4f71fd58df16548f2b0776c6291a9b",
"assets/assets/images/splash_animation.gif": "affe2189a8c285352c94e0ea2cdd29f6",
"assets/assets/images/text_logo.png": "c0f68f29c83ed011696129aa9f679c98",
"assets/assets/images/us.png": "0d66a03e26ed77a8b4de6e765bb04df2",
"assets/assets/images/wallet.PNG": "dbffb476676f8ba9de18de0d4e6e9fe6",
"assets/assets/images/welcome_bg.png": "f94735464ab52652b0179886968962d3",
"assets/assets/lottie/cancel.json": "2554839613f27dd8a94e9381315d637a",
"assets/assets/lottie/done.json": "521a19b8b22946888950dc7a7e0730d6",
"assets/assets/lottie/logOut.json": "48f255814aee1159eb6c3d44a5f6d5c9",
"assets/assets/lottie/noDataFound.json": "7d138a89185e148b462aa651323a5fbc",
"assets/assets/lottie/ripple.json": "cb7cae6c51b4b31fef78c534ab873b69",
"assets/assets/lottie/waitAnimation.json": "44c7fe4b6d4560189bdfd16e9e946972",
"assets/FontManifest.json": "1b9201d61ce614010cc3d42365c7c8f3",
"assets/fonts/MaterialIcons-Regular.otf": "a161a9f3c66359a8fddea20eb9ab2c5f",
"assets/NOTICES": "8b3461d0b143718fcfd3a29f6270a7a9",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "a52a77ef4ed84e4b38048b0ae9a06ff2",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"flutter_bootstrap.js": "6b88dd6c8373b93a09a5e001bdb643e8",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "21ecbf5b4e8fb15df51810383b4c6287",
"/": "21ecbf5b4e8fb15df51810383b4c6287",
"main.dart.js": "91d7ff237051ab2759788002d9947ef2",
"manifest.json": "7473a968a287916942f6a36c31364eb9",
"splash_animation.gif": "affe2189a8c285352c94e0ea2cdd29f6",
"version.json": "e9eb58db72d407be27e9fa052224c304"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
