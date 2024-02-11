// Auto-generated
let project = new Project('SpartXArmory_1_0_0');

project.addSources('Sources');
project.addLibrary("/home/ariel/ArmoryEngine/armsdk/armory");
project.addLibrary("/home/ariel/ArmoryEngine/armsdk/iron");
project.addParameter('armory.trait.internal.UniformsManager');
project.addParameter("--macro keep('armory.trait.internal.UniformsManager')");
project.addParameter('armory.trait.WalkNavigation');
project.addParameter("--macro keep('armory.trait.WalkNavigation')");
project.addParameter('arm.node.Spawner_enemigos');
project.addParameter("--macro keep('arm.node.Spawner_enemigos')");
project.addParameter('arm.node.MoveEnemy');
project.addParameter("--macro keep('arm.node.MoveEnemy')");
project.addShaders("build_SpartXArmory/compiled/Shaders/*.glsl", { noembed: false});
project.addAssets("build_SpartXArmory/compiled/Assets/**", { notinlist: true });
project.addAssets("build_SpartXArmory/compiled/Shaders/*.arm", { notinlist: true });
project.addAssets("/home/ariel/ArmoryEngine/armsdk/armory/Assets/brdf.png", { notinlist: true });
project.addAssets("/home/ariel/ArmoryEngine/armsdk/armory/Assets/smaa_area.png", { notinlist: true });
project.addAssets("/home/ariel/ArmoryEngine/armsdk/armory/Assets/smaa_search.png", { notinlist: true });
project.addLibrary("/home/ariel/ArmoryEngine/armsdk/lib/zui");
project.addAssets("/home/ariel/ArmoryEngine/armsdk/armory/Assets/font_default.ttf", { notinlist: false });
project.addDefine('arm_deferred');
project.addDefine('arm_csm');
project.addDefine('rp_hdr');
project.addDefine('rp_renderer=Deferred');
project.addDefine('rp_shadowmap');
project.addDefine('rp_shadowmap_cascade=1024');
project.addDefine('rp_shadowmap_cube=512');
project.addDefine('rp_background=World');
project.addDefine('rp_render_to_texture');
project.addDefine('rp_compositornodes');
project.addDefine('rp_antialiasing=SMAA');
project.addDefine('rp_supersampling=1');
project.addDefine('rp_ssgi=SSAO');
project.addDefine('rp_translucency');
project.addDefine('rp_gbuffer_emission');
project.addDefine('js-es=6');
project.addDefine('arm_assert_level=Warning');
project.addDefine('arm_noembed');
project.addDefine('arm_soundcompress');
project.addDefine('arm_audio');
project.addDefine('arm_ui');
project.addDefine('arm_skin');
project.addDefine('arm_morph_target');
project.addDefine('arm_particles');
project.addDefine('armory');


resolve(project);
