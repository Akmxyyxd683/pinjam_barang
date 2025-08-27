import {
  Controller,
  Post,
  Body,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { UsersService } from './users.service';
import { LoginUserDto } from './dto/user.dto';

@Controller('auth')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post('register')
  async register(@Body() LoginUserDto: LoginUserDto) {
    try {
      const user = await this.usersService.create(LoginUserDto);
      return {
        success: true,
        message: 'User registered successfully',
        data: {
          id: user.id,
          email: user.email,
          name: user.name,
          role: user.role,
          no_telp: user.no_telp,
          alamat: user.alamat,
        },
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message || 'Registration failed',
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Post('login')
  async login(@Body() loginUserDto: LoginUserDto) {
    try {
      const user = await this.usersService.login(loginUserDto);
      return {
        success: true,
        message: 'Login successful',
        data: {
          id: user.id,
          email: user.email,
          name: user.name,
          role: user.role,
          no_telp: user.no_telp,
          alamat: user.alamat,
        },
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: 'Invalid username or password',
        },
        HttpStatus.UNAUTHORIZED,
      );
    }
  }
}
