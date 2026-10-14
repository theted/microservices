import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;
import java.util.Optional;
import java.util.concurrent.Executors;

/**
 * Enterprise-grade, cloud-native, horizontally scalable computation of a single
 * Collatz step. Questions go through the Hailstone Center of Excellence.
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

    static final class HalvingStrategy implements HailstoneTransformationStrategy {
        @Override
        public long transform(long n) {
            return n / 2;
        }
    }

    static final class TriplePlusOneStrategy implements HailstoneTransformationStrategy {
        @Override
        public long transform(long n) {
            return 3 * n + 1;
        }
    }

    static final class HailstoneTransformationStrategyFactory {
        private static final HailstoneTransformationStrategyFactory INSTANCE =
                new HailstoneTransformationStrategyFactory();

        private HailstoneTransformationStrategyFactory() {}

        static HailstoneTransformationStrategyFactory getInstance() {
            return INSTANCE;
        }

        HailstoneTransformationStrategy forParity(Parity parity) {
            return switch (parity) {
                case EVEN -> new HalvingStrategy();
                case ODD -> new TriplePlusOneStrategy();
            };
        }
    }

    record CollatzStepRequest(long n) {
        static Optional<CollatzStepRequest> fromQuery(String query) {
            if (query == null) {
                return Optional.empty();
            }
            for (String pair : query.split("&")) {
                if (pair.startsWith("n=")) {
                    try {
                        long n = Long.parseLong(pair.substring(2));
                        return n > 0 ? Optional.of(new CollatzStepRequest(n)) : Optional.empty();
                    } catch (NumberFormatException e) {
                        return Optional.empty();
                    }
                }
            }
            return Optional.empty();
        }
    }

    record CollatzStepResponse(long next) {
        String toPlainText() {
            return Long.toString(next);
        }
    }

    static final class CollatzStepService {
        private final HailstoneTransformationStrategyFactory strategyFactory;

        CollatzStepService(HailstoneTransformationStrategyFactory strategyFactory) {
            this.strategyFactory = strategyFactory;
        }

        CollatzStepResponse process(CollatzStepRequest request) {
            HailstoneTransformationStrategy strategy = strategyFactory.forParity(Parity.of(request.n()));
            return new CollatzStepResponse(strategy.transform(request.n()));
        }
    }

    static final class CollatzStepController implements HttpHandler {
        private final CollatzStepService service;

        CollatzStepController(CollatzStepService service) {
            this.service = service;
        }

        @Override
        public void handle(HttpExchange exchange) throws IOException {
            Optional<CollatzStepRequest> request =
                    CollatzStepRequest.fromQuery(exchange.getRequestURI().getRawQuery());
            String body = request.map(service::process)
                    .map(CollatzStepResponse::toPlainText)
                    .orElse("need ?n=<positive integer>");
            byte[] bytes = body.getBytes(StandardCharsets.UTF_8);
            exchange.getResponseHeaders().set("Content-Type", "text/plain");
            exchange.sendResponseHeaders(request.isPresent() ? 200 : 400, bytes.length);
            try (var out = exchange.getResponseBody()) {
                out.write(bytes);
            }
        }
    }

    public static void main(String[] args) throws IOException {
        var service = new CollatzStepService(HailstoneTransformationStrategyFactory.getInstance());
        var server = HttpServer.create(new InetSocketAddress(8000), 0);
        server.createContext("/", new CollatzStepController(service));
        server.setExecutor(Executors.newVirtualThreadPerTaskExecutor());
        server.start();
        System.out.println("CollatzEnterpriseEdition 1.0.0-RELEASE started on :8000");
    }
}
