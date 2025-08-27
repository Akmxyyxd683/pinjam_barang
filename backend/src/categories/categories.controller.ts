import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { CategoriesService } from './categories.service';
import { CategoryDto } from './dto/category.dto';

@Controller('categories')
export class CategoriesController {
  constructor(private readonly categoriesService: CategoriesService) {}

  @Post('add')
  async create(@Body() categoryDto: CategoryDto) {
    try {
      return await this.categoriesService.create(categoryDto);
    } catch (error) {
      throw new HttpException(
        `Gagal menambahkan data: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get()
  async findAll() {
    try {
      return await this.categoriesService.findAll();
    } catch (error) {
      throw new HttpException(
        `Gagal mengambil data: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    const category = await this.categoriesService.findOne(+id);
    if (!category) {
      throw new HttpException(
        `category yang anda cari tidak ditemukan`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    } else {
      return category;
    }
  }

  @Patch(':id')
  async update(@Param('id') id: string, @Body() CategoryDto: CategoryDto) {
    try {
      const updated = await this.categoriesService.update(+id, CategoryDto);
      if (!updated) {
        throw new HttpException(
          `Gagal mencari category, pastikan id anda benar`,
          HttpStatus.NOT_FOUND,
        );
      } else {
        return updated;
      }
    } catch (error) {
      throw new HttpException(
        `Gagal update barang: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Delete(':id')
  async remove(@Param('id') id: string) {
    try {
      const deleted = await this.categoriesService.remove(+id);
      if (!deleted) {
        throw new HttpException(
          `Gagal menghapus barang, pastikan id anda benar`,
          HttpStatus.NOT_FOUND,
        );
      } else {
        return deleted;
      }
    } catch (error) {
      throw new HttpException(
        `Gagal menghapus barang: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }
}
