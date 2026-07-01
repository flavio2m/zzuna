import 'package:flutter_test/flutter_test.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';

void main() {
  group('LancamentoGrupo Unit Tests', () {
    group('Parcelamento', () {
      test('deve criar uma instância válida e preservar parcela e totalParcelas', () {
        const grupo = LancamentoGrupo.parcelamento(
          grupoId: 'grupo-123',
          parcela: 2,
          totalParcelas: 10,
        );

        expect(grupo, isA<LancamentoGrupoParcelamento>());
        final parcelamento = grupo as LancamentoGrupoParcelamento;
        expect(parcelamento.grupoId, equals('grupo-123'));
        expect(parcelamento.parcela, equals(2));
        expect(parcelamento.totalParcelas, equals(10));
      });

      test('deve serializar e desserializar corretamente mantendo parcela e totalParcelas', () {
        const grupoOriginal = LancamentoGrupo.parcelamento(
          grupoId: 'grupo-abc',
          parcela: 3,
          totalParcelas: 12,
        );

        final json = grupoOriginal.toJson();
        final grupoDesserializado = LancamentoGrupo.fromJson(json);

        expect(grupoDesserializado, equals(grupoOriginal));
        expect(grupoDesserializado, isA<LancamentoGrupoParcelamento>());
        
        final parcelamento = grupoDesserializado as LancamentoGrupoParcelamento;
        expect(parcelamento.grupoId, equals('grupo-abc'));
        expect(parcelamento.parcela, equals(3));
        expect(parcelamento.totalParcelas, equals(12));
      });

      test('deve suportar igualdade e copyWith corretamente', () {
        const grupo1 = LancamentoGrupo.parcelamento(
          grupoId: 'g1',
          parcela: 1,
          totalParcelas: 5,
        );
        const grupo2 = LancamentoGrupo.parcelamento(
          grupoId: 'g1',
          parcela: 1,
          totalParcelas: 5,
        );
        const grupoDiferente = LancamentoGrupo.parcelamento(
          grupoId: 'g1',
          parcela: 2,
          totalParcelas: 5,
        );

        expect(grupo1, equals(grupo2));
        expect(grupo1.hashCode, equals(grupo2.hashCode));
        expect(grupo1, isNot(equals(grupoDiferente)));

        final copiado = (grupo1 as LancamentoGrupoParcelamento).copyWith(parcela: 2);
        expect(copiado, equals(grupoDiferente));
      });
    });

    group('Transferencia', () {
      test('deve serializar e desserializar corretamente', () {
        const grupo = LancamentoGrupo.transferencia(grupoId: 'trans-1');
        final json = grupo.toJson();
        final deserialized = LancamentoGrupo.fromJson(json);

        expect(deserialized, equals(grupo));
        expect(deserialized, isA<LancamentoGrupoTransferencia>());
      });

      test('deve testar igualdade e copyWith', () {
        const t1 = LancamentoGrupo.transferencia(grupoId: 't1');
        const t2 = LancamentoGrupo.transferencia(grupoId: 't1');
        expect(t1, equals(t2));

        final copiado = (t1 as LancamentoGrupoTransferencia).copyWith(grupoId: 't2');
        expect(copiado.grupoId, equals('t2'));
      });
    });

    group('Replicacao', () {
      test('deve serializar e desserializar corretamente mantendo parcela e totalParcelas', () {
        const grupo = LancamentoGrupo.replicacao(
          grupoId: 'rep-1',
          parcela: 1,
          totalParcelas: 5,
        );
        final json = grupo.toJson();
        final deserialized = LancamentoGrupo.fromJson(json);

        expect(deserialized, equals(grupo));
        expect(deserialized, isA<LancamentoGrupoReplicacao>());

        final rep = deserialized as LancamentoGrupoReplicacao;
        expect(rep.grupoId, equals('rep-1'));
        expect(rep.parcela, equals(1));
        expect(rep.totalParcelas, equals(5));
      });

      test('deve testar igualdade e copyWith', () {
        const r1 = LancamentoGrupo.replicacao(
          grupoId: 'r1',
          parcela: 1,
          totalParcelas: 5,
        );
        const r2 = LancamentoGrupo.replicacao(
          grupoId: 'r1',
          parcela: 1,
          totalParcelas: 5,
        );
        expect(r1, equals(r2));

        final copiado = (r1 as LancamentoGrupoReplicacao).copyWith(parcela: 2);
        expect(copiado.parcela, equals(2));
      });
    });
  });
}
