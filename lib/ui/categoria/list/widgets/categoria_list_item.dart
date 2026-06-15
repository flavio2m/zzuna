import 'package:flutter/material.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/ui/categoria/delete/widgets/categoria_delete_button.dart';
import 'package:zzuna/ui/categoria/update/widgets/categoria_update_modal.dart';
import 'package:zzuna/ui/shared/widgets/tags/app_tag.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/buttons/icons_buttons/icon_editar_button.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';

class CategoriaListItem extends StatelessWidget {
  final CategoriaDetails categoria;

  /// Nome da categoria pai — já resolvido pela view, null se for raiz
  final String? nomePai;

  final bool isColapsada;
  final VoidCallback? onToggle;
  final int profundidade;

  const CategoriaListItem({
    super.key,
    required this.categoria,
    this.nomePai,
    this.isColapsada = false,
    this.onToggle,
    this.profundidade = 0,
  });

  void _editarCategoria(BuildContext context) {
    final dto = CategoriaDto(
      id: categoria.id,
      descricao: categoria.descricao,
      categoriaPaiId: categoria.categoriaPai?.id,
      ativo: categoria.ativo,
    );
    CategoriaUpdateModal.show(
      context,
      dto,
      temSubcategorias: categoria.subcategorias.isNotEmpty, //
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRaiz = categoria.categoriaPai == null;
    final temSubcategorias = categoria.subcategorias.isNotEmpty;

    return SizedBox(
      height: 38,
      child: Row(
        children: [
          // Recuo proporcional ao nível/profundidade na hierarquia
          if (profundidade > 0) SizedBox(width: profundidade * 16.0),

          // Botão expandir/colapsar apenas para raízes (ou nós com filhos) com subcategorias
          if (temSubcategorias)
            SizedBox(
              width: 28,
              height: 28,
              child: IconButton(
                padding: EdgeInsets.zero,
                iconSize: 16,
                tooltip: isColapsada ? 'Expandir' : 'Recolher',
                icon: AnimatedRotation(
                  turns: isColapsada ? -0.25 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: const Icon(Icons.expand_more, size: 16),
                ),
                color: AppColors.slate500,
                onPressed: onToggle,
              ),
            )
          else
            // Espaço de alinhamento quando não tem botão de expansão
            const SizedBox(width: 28),

          Icon(
            isRaiz ? Icons.account_tree : Icons.subdirectory_arrow_right,
            size: 18,
            color: categoria.ativo ? AppColors.primary : AppColors.slate400,
          ),

          const AppSpacing(size: AppSpacingSize.xs, axis: Axis.horizontal),

          Expanded(
            child: Row(
              children: [
                Flexible(child: AppText(categoria.descricao, overflow: TextOverflow.ellipsis)),

                if (nomePai != null) ...[
                  const AppSpacing(size: AppSpacingSize.xs, axis: Axis.horizontal),
                  AppTag(nomePai!),
                ],

                if (!categoria.ativo) ...[
                  const AppSpacing(size: AppSpacingSize.xs, axis: Axis.horizontal),
                  AppTag('Inativo'),
                ],
              ],
            ),
          ),

          IconEditarButton(onPressed: () => _editarCategoria(context)),

          CategoriaDeleteButton(categoriaId: categoria.id, categoriaDescricao: categoria.descricao),

          const AppSpacing(size: AppSpacingSize.sm, axis: Axis.horizontal),
        ],
      ),
    );
  }
}
