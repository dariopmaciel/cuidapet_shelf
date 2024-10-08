import './i_logger.dart';
import 'package:logger/logger.dart' as log;


//pacotes de apresentação de log - apresentação por cor
class ILoggerImpl implements ILogger {
  //variavel pq a clsse tem o menos nome devo fazer jogada as log no pacote
  
  final _logger = log.Logger();

  @override
  void debug(message, [error, StackTrace? stackTrace]) =>
      _logger.d(message, error: error, stackTrace: stackTrace);

  @override
  void error(message, [error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);

  @override
  void info(message, [error, StackTrace? stackTrace]) =>
      _logger.i(message, error: error, stackTrace: stackTrace);

  @override
  void warning(message, [error, StackTrace? stackTrace]) =>
      _logger.w(message, error: error, stackTrace: stackTrace);
}
