import java.util.Scanner;

/**
 * One hailstone step, Enterprise Edition: a strategy factory decides between
 * halving and tripling, because an if statement would not scale.
 */
public final class CollatzEnterpriseEdition {

    enum Parity {
        EVEN,
        ODD;

        static Parity of(long n) {
            return n % 2 == 0 ? EVEN : ODD;
        }
    }

    interface HailstoneTransformationStrategy {
        long transform(long n);
    }

    static final class HailstoneTransformationStrategyFactory {
        private static final HailstoneTransformationStrategyFactory INSTANCE =
                new HailstoneTransformationStrategyFactory();

        static HailstoneTransformationStrategyFactory getInstance() {
            return INSTANCE;
        }

        HailstoneTransformationStrategy forParity(Parity parity) {
            return switch (parity) {
                case EVEN -> n -> n / 2;
                case ODD -> n -> 3 * n + 1;
            };
        }
    }

    public static void main(String[] args) {
        long n = new Scanner(System.in).nextLong();
        HailstoneTransformationStrategy strategy =
                HailstoneTransformationStrategyFactory.getInstance().forParity(Parity.of(n));
        System.out.println(strategy.transform(n));
    }
}
