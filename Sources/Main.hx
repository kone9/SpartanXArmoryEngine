// Auto-generated
package ;
class Main {
    public static inline var projectName = 'SpartXArmory';
    public static inline var projectVersion = '1.0.0';
    public static inline var projectPackage = 'arm';
    public static function main() {
        iron.object.BoneAnimation.skinMaxBones = 82;
            iron.object.LightObject.cascadeCount = 4;
            iron.object.LightObject.cascadeSplitFactor = 0.800000011920929;
        armory.system.Starter.main(
            'main',
            0,
            false,
            true,
            false,
            960,
            540,
            1,
            true,
            armory.renderpath.RenderPathCreator.get
        );
    }
}
